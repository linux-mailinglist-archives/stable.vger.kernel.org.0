Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E80C2A15E3
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgJaLjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgJaLfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE2F20791;
        Sat, 31 Oct 2020 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144142;
        bh=Shky6g4OVk/6gYK00B9yQQdG33qHJEk0/XWJz/WoXB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeyhI1Uc7oPqq3Tbey0qSCPSuuFB1ovShGZg9YGuPD3hCWdjk1zAy5tFC4F5Ejayj
         OQPnmzJMNJg/c4h2d1hzamRAMGbuG2eXQwyCZQNQynE0fuufDT3Tf4Diyqmf+KsW6M
         1kh9AffKIblP38as3S/FONBW72mzlCtdnmAjJVq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 20/49] net/sched: act_mpls: Add softdep on mpls_gso.ko
Date:   Sat, 31 Oct 2020 12:35:16 +0100
Message-Id: <20201031113456.421810087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
packets. Such packets will thus require mpls_gso.ko for segmentation.

v2: Drop dependency on CONFIG_NET_MPLS_GSO in Kconfig (from Jakub and
    David).

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mpls.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -408,6 +408,7 @@ static void __exit mpls_cleanup_module(v
 module_init(mpls_init_module);
 module_exit(mpls_cleanup_module);
 
+MODULE_SOFTDEP("post: mpls_gso");
 MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MPLS manipulation actions");


