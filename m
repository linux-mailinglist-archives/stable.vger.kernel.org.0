Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94C71EAF17
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgFAS7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgFAR5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4CD206E2;
        Mon,  1 Jun 2020 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034241;
        bh=6fU6roTFzC+TA+Ol0XxJWSS2BpufeCtqNSOpSiz+trk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLrTJ8U/ZVn0J7wsM8hHSxBtTUtndeWYwqPBpf/vye7FsfdqpKTdEZZJk/0Wpn+RQ
         RehXDlkCtoch2obZSM2c118XILB90riNszmUQM6vcclB/psbFoYQstsHeeAqMRVbue
         sJbdB3Nc5P2pNLpLDZrOAxqNMNQSoPWlfDY14hYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 38/48] netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build
Date:   Mon,  1 Jun 2020 19:53:48 +0200
Message-Id: <20200601174003.198014582@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
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


