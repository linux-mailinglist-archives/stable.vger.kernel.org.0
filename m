Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D864D10BD2D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbfK0VZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfK0VCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21DFD21741;
        Wed, 27 Nov 2019 21:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888535;
        bh=DjyCqwt1ga+lwVJAsjsS0ynYp2uQ2lXOueGsNp5OE3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H34oYTGqIdTesIm2xfkgUdtUFXeYnxT49/Uc3SFK2AwBiUS/ux65WMVzJb7OV4Z26
         3XmOK2eFm/YFkAUfc1bvOMKl8w5V3PixvQWjOT2QN/jh4DoAY3vL9tb3dsFwBwH/xR
         rc8CzJoRj3EjQbFFwMZCjmTLWBCgJmazxscO+Egs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/306] sparc64: Rework xchg() definition to avoid warnings.
Date:   Wed, 27 Nov 2019 21:29:55 +0100
Message-Id: <20191127203125.953952831@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 6c2fc9cddc1ffdef8ada1dc8404e5affae849953 ]

Such as:

fs/ocfs2/file.c: In function ‘ocfs2_file_write_iter’:
./arch/sparc/include/asm/cmpxchg_64.h:55:22: warning: value computed is not used [-Wunused-value]
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))

and

drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_xdp_setup’:
./arch/sparc/include/asm/cmpxchg_64.h:55:22: warning: value computed is not used [-Wunused-value]
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/cmpxchg_64.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/cmpxchg_64.h b/arch/sparc/include/asm/cmpxchg_64.h
index f71ef3729888f..316faa0130bab 100644
--- a/arch/sparc/include/asm/cmpxchg_64.h
+++ b/arch/sparc/include/asm/cmpxchg_64.h
@@ -52,7 +52,12 @@ static inline unsigned long xchg64(__volatile__ unsigned long *m, unsigned long
 	return val;
 }
 
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+#define xchg(ptr,x)							\
+({	__typeof__(*(ptr)) __ret;					\
+	__ret = (__typeof__(*(ptr)))					\
+		__xchg((unsigned long)(x), (ptr), sizeof(*(ptr)));	\
+	__ret;								\
+})
 
 void __xchg_called_with_bad_pointer(void);
 
-- 
2.20.1



