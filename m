Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA46122642A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgGTPml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbgGTPmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A2262065E;
        Mon, 20 Jul 2020 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259759;
        bh=wmm6NsdC1485i7PvcGDRmo3nlp7PhRzh9M8B+nfFdL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4KtjeK86drSEUNR8gHwxKYSPtEkec/6XKidhsqphhPLYiMhYapK1gs3qhtzeXlhP
         p3SFOtVyjOfjChvmCUHBx712KLoa1LX8FDQHPOxiiyfyh6VL+qrx0laKV5ZDfPElsx
         isnudHnoJkI6wdQ9d6wcmvmG7GT3oAjDidweReco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 39/86] cgroup: Fix sock_cgroup_data on big-endian.
Date:   Mon, 20 Jul 2020 17:36:35 +0200
Message-Id: <20200720152755.134952698@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 14b032b8f8fce03a546dcf365454bec8c4a58d7d ]

In order for no_refcnt and is_data to be the lowest order two
bits in the 'val' we have to pad out the bitfield of the u8.

Fixes: ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -589,6 +589,7 @@ struct sock_cgroup_data {
 		struct {
 			u8	is_data : 1;
 			u8	no_refcnt : 1;
+			u8	unused : 6;
 			u8	padding;
 			u16	prioidx;
 			u32	classid;
@@ -598,6 +599,7 @@ struct sock_cgroup_data {
 			u32	classid;
 			u16	prioidx;
 			u8	padding;
+			u8	unused : 6;
 			u8	no_refcnt : 1;
 			u8	is_data : 1;
 		} __packed;


