Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06207566E32
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiGEMb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbiGEM0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4756E1903A;
        Tue,  5 Jul 2022 05:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB1FB817C7;
        Tue,  5 Jul 2022 12:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C624C341C7;
        Tue,  5 Jul 2022 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023551;
        bh=uH5hwoUgvFMaW/KRDM26xR9+SlNqEoaBUR7HfMngWTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APZh4ll5yMSj+GU8rK3LCAi3n29ZoDMQn59j8tb3SF/7Z41SSl5VSrYOozlPm93vQ
         E5kujKQHPSGdP/aV6h6FQnkgP5NUVbrLZFwn5vZxHdtWUWKMYZq/b9kFFszqTeiJ5D
         egVdavfnKuJo0Ny0gjS9W+hEIkX3XD8zUfe27Drs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.18 101/102] xen-netfront: restore __skb_queue_tail() positioning in xennet_get_responses()
Date:   Tue,  5 Jul 2022 13:59:07 +0200
Message-Id: <20220705115621.284687032@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
@@ -1094,8 +1094,10 @@ static int xennet_get_responses(struct n
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
 


