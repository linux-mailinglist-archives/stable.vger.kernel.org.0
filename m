Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C006137E83
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgAKKKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:10:48 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8B5920673;
        Sat, 11 Jan 2020 10:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737448;
        bh=J0cPKhFxQCuZu+uLL9G/eNDy4tjEa8vlQ6PtGjaXh5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjRgztevO2APNaH4Gzf/zopg2VOMVvrJ9R5KpZMJO+WMHj6YlQVNyJaNrJN/n5F2A
         6tE6c6Ve6tsDddqFJfb7RhGyKC8Cia/vhnQnxjNaK5AlwNmMonA2Icghk0UAkGG1fW
         6q38WUxf+F2fIVCSEdAASXPAchX5QansVjFDK2l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/62] netfilter: uapi: Avoid undefined left-shift in xt_sctp.h
Date:   Sat, 11 Jan 2020 10:49:54 +0100
Message-Id: <20200111094842.530267605@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 164166558aacea01b99c8c8ffb710d930405ba69 ]

With 'bytes(__u32)' being 32, a left-shift of 31 may happen which is
undefined for the signed 32-bit value 1. Avoid this by declaring 1 as
unsigned.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_sctp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_sctp.h b/include/uapi/linux/netfilter/xt_sctp.h
index 4bc6d1a08781..b4d804a9fccb 100644
--- a/include/uapi/linux/netfilter/xt_sctp.h
+++ b/include/uapi/linux/netfilter/xt_sctp.h
@@ -41,19 +41,19 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
 		(chunkmap)[type / bytes(__u32)] |= 	\
-			1 << (type % bytes(__u32));	\
+			1u << (type % bytes(__u32));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
 		(chunkmap)[type / bytes(__u32)] &= 		\
-			~(1 << (type % bytes(__u32)));	\
+			~(1u << (type % bytes(__u32)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
 	((chunkmap)[type / bytes (__u32)] & 		\
-		(1 << (type % bytes (__u32)))) ? 1: 0;	\
+		(1u << (type % bytes (__u32)))) ? 1: 0;	\
 })
 
 #define SCTP_CHUNKMAP_RESET(chunkmap) \
-- 
2.20.1



