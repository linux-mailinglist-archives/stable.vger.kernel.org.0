Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074715219D5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244941AbiEJNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245711AbiEJNsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46B52A975B;
        Tue, 10 May 2022 06:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A72F1B81DB2;
        Tue, 10 May 2022 13:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107AAC385C2;
        Tue, 10 May 2022 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189759;
        bh=lr/NUffgJ5GFBk69yG43Atq4uEX7MxnvVMYzJipYg/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQ/Bv3NbjE+A0wx/NmJ8jsefkgZOtizwQLXTTQf33V2nIF1xce4aInksHQwmqwsDo
         jCIWmiAT3+yE0lCH4tuHqhkYe/dX03JttYAkVL5Z5btWaN6Ulc3Xge77YUfgJpJEG4
         tX0inieIx5aXTUZlxnrpGoyl7N+MiCn2kQncpNo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Wiese <jwiese@rackspace.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.17 002/140] ipmi: When handling send message responses, dont process the message
Date:   Tue, 10 May 2022 15:06:32 +0200
Message-Id: <20220510130741.672481054@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

commit 3d092ef09303e615707dc5755cf0e29b4df7555f upstream.

A chunk was dropped when the code handling send messages was rewritten.
Those messages shouldn't be processed normally, they are just an
indication that the message was successfully sent and the timers should
be started for the real response that should be coming later.

Add back in the missing chunk to just discard the message and go on.

Fixes: 059747c245f0 ("ipmi: Add support for IPMB direct messages")
Reported-by: Joe Wiese <jwiese@rackspace.com>
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Joe Wiese <jwiese@rackspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4518,6 +4518,8 @@ return_unspecified:
 		} else
 			/* The message was sent, start the timer. */
 			intf_start_seq_timer(intf, msg->msgid);
+		requeue = 0;
+		goto out;
 	} else if (((msg->rsp[0] >> 2) != ((msg->data[0] >> 2) | 1))
 		   || (msg->rsp[1] != msg->data[1])) {
 		/*


