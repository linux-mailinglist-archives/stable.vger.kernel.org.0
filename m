Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D9566C3D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiGEMNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiGEML0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:11:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D69019291;
        Tue,  5 Jul 2022 05:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD6D3B817C7;
        Tue,  5 Jul 2022 12:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D5EC341C7;
        Tue,  5 Jul 2022 12:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023005;
        bh=ZxJNrdgMiyPXeyI/MxyTOs7moBMFs7SG2YA8K8smP94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adMY5yx5B0MLaSgQPjCBbdmojjDdaUSCJDdN59lN9a/BBs/ALVSsMM01zin+H0G7H
         yzaNkARJngMgwCHTKioL3Cy8ujTJQqE21uhFdTU1xlCLF4SXJvLnTPkxwh+XU82G7N
         1ttIXza2NfqOXoup5eg5+U03PjykgGcwcUwL3R9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 80/84] xen-netfront: restore __skb_queue_tail() positioning in xennet_get_responses()
Date:   Tue,  5 Jul 2022 13:58:43 +0200
Message-Id: <20220705115617.653866894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit f63c2c2032c2e3caad9add3b82cc6e91c376fd26 upstream.

The commit referenced below moved the invocation past the "next" label,
without any explanation. In fact this allows misbehaving backends undue
control over the domain the frontend runs in, as earlier detected errors
require the skb to not be freed (it may be retained for later processing
via xennet_move_rx_slot(), or it may simply be unsafe to have it freed).

This is CVE-2022-33743 / XSA-405.

Fixes: 6c5aa6fc4def ("xen networking: add basic XDP support for xen-netfront")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1096,8 +1096,10 @@ static int xennet_get_responses(struct n
 			}
 		}
 		rcu_read_unlock();
-next:
+
 		__skb_queue_tail(list, skb);
+
+next:
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 


