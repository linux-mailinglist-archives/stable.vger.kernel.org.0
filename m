Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F52265B7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbgGTP4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731357AbgGTP4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BBE22BEF;
        Mon, 20 Jul 2020 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260596;
        bh=zfkmZazsiNFYPb41AvpLojFzYhefHY8dWGULRGKq0Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmVs6T7gM01RBbFMdbSxjPYNH6ta+bpK5w6FXaZnATYUwJhiTwUMvrRNJjIzuoWOM
         fgTRthGHR3f4gfBkkZLPtNdubu0jIdgUzlCyh7hrfyOph0l+CxNjJdQpUWvOHRgM5w
         mqbIaU4Cru9qG+e+F8mybG9yNktg8UCIMOBwQdgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 025/215] cgroup: Fix sock_cgroup_data on big-endian.
Date:   Mon, 20 Jul 2020 17:35:07 +0200
Message-Id: <20200720152821.377595176@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
@@ -799,6 +799,7 @@ struct sock_cgroup_data {
 		struct {
 			u8	is_data : 1;
 			u8	no_refcnt : 1;
+			u8	unused : 6;
 			u8	padding;
 			u16	prioidx;
 			u32	classid;
@@ -808,6 +809,7 @@ struct sock_cgroup_data {
 			u32	classid;
 			u16	prioidx;
 			u8	padding;
+			u8	unused : 6;
 			u8	no_refcnt : 1;
 			u8	is_data : 1;
 		} __packed;


