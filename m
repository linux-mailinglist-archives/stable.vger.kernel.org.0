Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611351EA936
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgFAR7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgFAR7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:59:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4FD2073B;
        Mon,  1 Jun 2020 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034353;
        bh=6fU6roTFzC+TA+Ol0XxJWSS2BpufeCtqNSOpSiz+trk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eRdaAbVR676/88QTKFbiWBUtJv/Mkon48augKocrPzYd++rOgvjcUXulpIqDAIv+
         596QW9HH4ePY5FgQMBtuuJKVYcNu89PVfEAslIcfPovATjjiq9j/aX7OEfICcR4k7R
         Jja3JVLFzuWO1bsvJmu/mOYxljgLc8COzfD88zEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9 56/61] netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build
Date:   Mon,  1 Jun 2020 19:54:03 +0200
Message-Id: <20200601174021.915757425@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4946ea5c1237036155c3b3a24f049fd5f849f8f6 upstream.

>> include/linux/netfilter/nf_conntrack_pptp.h:13:20: warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
extern const char *const pptp_msg_name(u_int16_t msg);
^~~~~~

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 4c559f15efcc ("netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netfilter/nf_conntrack_pptp.h |    2 +-
 net/netfilter/nf_conntrack_pptp.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -4,7 +4,7 @@
 
 #include <linux/netfilter/nf_conntrack_common.h>
 
-extern const char *const pptp_msg_name(u_int16_t msg);
+const char *pptp_msg_name(u_int16_t msg);
 
 /* state of the control session */
 enum pptp_ctrlsess_state {
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -90,7 +90,7 @@ static const char *const pptp_msg_name_a
 	[PPTP_SET_LINK_INFO]		= "SET_LINK_INFO"
 };
 
-const char *const pptp_msg_name(u_int16_t msg)
+const char *pptp_msg_name(u_int16_t msg)
 {
 	if (msg > PPTP_MSG_MAX)
 		return pptp_msg_name_array[0];


