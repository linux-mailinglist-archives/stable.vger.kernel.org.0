Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA17318E8F
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBKP33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhBKP05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:26:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DA764EC9;
        Thu, 11 Feb 2021 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055828;
        bh=ZFcLfTMHJpVmW+Qgh8W6WNIdzkO2s/1s5+MiBxyEikc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4TA0rmORugznvtH2MnqSOEANZzQblokJK3LHjNj/yxj8h2XC53MIYYK7CmQOaey0
         2vUyggbPN24OU9yShTTWp6p6E+iyTEGHnGTsYE23oV3FvjGchfosZXrnpdobUDxXjR
         A5uXuMmbw+Q9jbjcFXEz9imSj47wk/wsd/M3qmEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/54] drm/nouveau/nvif: fix method count when pushing an array
Date:   Thu, 11 Feb 2021 16:02:06 +0100
Message-Id: <20210211150153.851623903@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit d502297008142645edf5c791af424ed321e5da84 ]

Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/include/nvif/push.h | 216 ++++++++++----------
 1 file changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvif/push.h b/drivers/gpu/drm/nouveau/include/nvif/push.h
index 168d7694ede5c..6d3a8a3d2087b 100644
--- a/drivers/gpu/drm/nouveau/include/nvif/push.h
+++ b/drivers/gpu/drm/nouveau/include/nvif/push.h
@@ -123,131 +123,131 @@ PUSH_KICK(struct nvif_push *push)
 } while(0)
 #endif
 
-#define PUSH_1(X,f,ds,n,c,o,p,s,mA,dA) do {                            \
-	PUSH_##o##_HDR((p), s, mA, (c)+(n));                           \
-	PUSH_##f(X, (p), X##mA, 1, o, (dA), ds, "");                   \
+#define PUSH_1(X,f,ds,n,o,p,s,mA,dA) do {                             \
+	PUSH_##o##_HDR((p), s, mA, (ds)+(n));                         \
+	PUSH_##f(X, (p), X##mA, 1, o, (dA), ds, "");                  \
 } while(0)
-#define PUSH_2(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (1?PUSH_##o##_INC), "mthd1");       \
-	PUSH_1(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_2(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (1?PUSH_##o##_INC), "mthd1");      \
+	PUSH_1(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_3(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd2");       \
-	PUSH_2(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_3(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd2");      \
+	PUSH_2(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_4(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd3");       \
-	PUSH_3(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_4(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd3");      \
+	PUSH_3(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_5(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd4");       \
-	PUSH_4(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_5(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd4");      \
+	PUSH_4(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_6(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd5");       \
-	PUSH_5(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_6(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd5");      \
+	PUSH_5(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_7(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd6");       \
-	PUSH_6(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_7(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd6");      \
+	PUSH_6(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_8(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd7");       \
-	PUSH_7(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_8(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd7");      \
+	PUSH_7(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_9(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                 \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd8");       \
-	PUSH_8(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_9(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                  \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd8");      \
+	PUSH_8(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
-#define PUSH_10(X,f,ds,n,c,o,p,s,mB,dB,mA,dA,a...) do {                \
-	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd9");       \
-	PUSH_9(X, DATA_, 1, ds, (c)+(n), o, (p), s, X##mA, (dA), ##a); \
-	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                   \
+#define PUSH_10(X,f,ds,n,o,p,s,mB,dB,mA,dA,a...) do {                 \
+	PUSH_ASSERT((mB) - (mA) == (0?PUSH_##o##_INC), "mthd9");      \
+	PUSH_9(X, DATA_, 1, (ds) + (n), o, (p), s, X##mA, (dA), ##a); \
+	PUSH_##f(X, (p), X##mB, 0, o, (dB), ds, "");                  \
 } while(0)
 
-#define PUSH_1D(X,o,p,s,mA,dA)                            \
-	PUSH_1(X, DATA_, 1, 1, 0, o, (p), s, X##mA, (dA))
-#define PUSH_2D(X,o,p,s,mA,dA,mB,dB)                      \
-	PUSH_2(X, DATA_, 1, 1, 0, o, (p), s, X##mB, (dB), \
-					     X##mA, (dA))
-#define PUSH_3D(X,o,p,s,mA,dA,mB,dB,mC,dC)                \
-	PUSH_3(X, DATA_, 1, 1, 0, o, (p), s, X##mC, (dC), \
-					     X##mB, (dB), \
-					     X##mA, (dA))
-#define PUSH_4D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD)          \
-	PUSH_4(X, DATA_, 1, 1, 0, o, (p), s, X##mD, (dD), \
-					     X##mC, (dC), \
-					     X##mB, (dB), \
-					     X##mA, (dA))
-#define PUSH_5D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE)    \
-	PUSH_5(X, DATA_, 1, 1, 0, o, (p), s, X##mE, (dE), \
-					     X##mD, (dD), \
-					     X##mC, (dC), \
-					     X##mB, (dB), \
-					     X##mA, (dA))
+#define PUSH_1D(X,o,p,s,mA,dA)                         \
+	PUSH_1(X, DATA_, 1, 0, o, (p), s, X##mA, (dA))
+#define PUSH_2D(X,o,p,s,mA,dA,mB,dB)                   \
+	PUSH_2(X, DATA_, 1, 0, o, (p), s, X##mB, (dB), \
+					  X##mA, (dA))
+#define PUSH_3D(X,o,p,s,mA,dA,mB,dB,mC,dC)             \
+	PUSH_3(X, DATA_, 1, 0, o, (p), s, X##mC, (dC), \
+					  X##mB, (dB), \
+					  X##mA, (dA))
+#define PUSH_4D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD)       \
+	PUSH_4(X, DATA_, 1, 0, o, (p), s, X##mD, (dD), \
+					  X##mC, (dC), \
+					  X##mB, (dB), \
+					  X##mA, (dA))
+#define PUSH_5D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE) \
+	PUSH_5(X, DATA_, 1, 0, o, (p), s, X##mE, (dE), \
+					  X##mD, (dD), \
+					  X##mC, (dC), \
+					  X##mB, (dB), \
+					  X##mA, (dA))
 #define PUSH_6D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE,mF,dF) \
-	PUSH_6(X, DATA_, 1, 1, 0, o, (p), s, X##mF, (dF),    \
-					     X##mE, (dE),    \
-					     X##mD, (dD),    \
-					     X##mC, (dC),    \
-					     X##mB, (dB),    \
-					     X##mA, (dA))
+	PUSH_6(X, DATA_, 1, 0, o, (p), s, X##mF, (dF),       \
+					  X##mE, (dE),       \
+					  X##mD, (dD),       \
+					  X##mC, (dC),       \
+					  X##mB, (dB),       \
+					  X##mA, (dA))
 #define PUSH_7D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE,mF,dF,mG,dG) \
-	PUSH_7(X, DATA_, 1, 1, 0, o, (p), s, X##mG, (dG),          \
-					     X##mF, (dF),          \
-					     X##mE, (dE),          \
-					     X##mD, (dD),          \
-					     X##mC, (dC),          \
-					     X##mB, (dB),          \
-					     X##mA, (dA))
+	PUSH_7(X, DATA_, 1, 0, o, (p), s, X##mG, (dG),             \
+					  X##mF, (dF),             \
+					  X##mE, (dE),             \
+					  X##mD, (dD),             \
+					  X##mC, (dC),             \
+					  X##mB, (dB),             \
+					  X##mA, (dA))
 #define PUSH_8D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE,mF,dF,mG,dG,mH,dH) \
-	PUSH_8(X, DATA_, 1, 1, 0, o, (p), s, X##mH, (dH),                \
-					     X##mG, (dG),                \
-					     X##mF, (dF),                \
-					     X##mE, (dE),                \
-					     X##mD, (dD),                \
-					     X##mC, (dC),                \
-					     X##mB, (dB),                \
-					     X##mA, (dA))
+	PUSH_8(X, DATA_, 1, 0, o, (p), s, X##mH, (dH),                   \
+					  X##mG, (dG),                   \
+					  X##mF, (dF),                   \
+					  X##mE, (dE),                   \
+					  X##mD, (dD),                   \
+					  X##mC, (dC),                   \
+					  X##mB, (dB),                   \
+					  X##mA, (dA))
 #define PUSH_9D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE,mF,dF,mG,dG,mH,dH,mI,dI) \
-	PUSH_9(X, DATA_, 1, 1, 0, o, (p), s, X##mI, (dI),                      \
-					     X##mH, (dH),                      \
-					     X##mG, (dG),                      \
-					     X##mF, (dF),                      \
-					     X##mE, (dE),                      \
-					     X##mD, (dD),                      \
-					     X##mC, (dC),                      \
-					     X##mB, (dB),                      \
-					     X##mA, (dA))
+	PUSH_9(X, DATA_, 1, 0, o, (p), s, X##mI, (dI),                         \
+					  X##mH, (dH),                         \
+					  X##mG, (dG),                         \
+					  X##mF, (dF),                         \
+					  X##mE, (dE),                         \
+					  X##mD, (dD),                         \
+					  X##mC, (dC),                         \
+					  X##mB, (dB),                         \
+					  X##mA, (dA))
 #define PUSH_10D(X,o,p,s,mA,dA,mB,dB,mC,dC,mD,dD,mE,dE,mF,dF,mG,dG,mH,dH,mI,dI,mJ,dJ) \
-	PUSH_10(X, DATA_, 1, 1, 0, o, (p), s, X##mJ, (dJ),                            \
-					      X##mI, (dI),                            \
-					      X##mH, (dH),                            \
-					      X##mG, (dG),                            \
-					      X##mF, (dF),                            \
-					      X##mE, (dE),                            \
-					      X##mD, (dD),                            \
-					      X##mC, (dC),                            \
-					      X##mB, (dB),                            \
-					      X##mA, (dA))
+	PUSH_10(X, DATA_, 1, 0, o, (p), s, X##mJ, (dJ),                               \
+					   X##mI, (dI),                               \
+					   X##mH, (dH),                               \
+					   X##mG, (dG),                               \
+					   X##mF, (dF),                               \
+					   X##mE, (dE),                               \
+					   X##mD, (dD),                               \
+					   X##mC, (dC),                               \
+					   X##mB, (dB),                               \
+					   X##mA, (dA))
 
-#define PUSH_1P(X,o,p,s,mA,dp,ds)                           \
-	PUSH_1(X, DATAp, ds, ds, 0, o, (p), s, X##mA, (dp))
-#define PUSH_2P(X,o,p,s,mA,dA,mB,dp,ds)                     \
-	PUSH_2(X, DATAp, ds, ds, 0, o, (p), s, X##mB, (dp), \
-					       X##mA, (dA))
-#define PUSH_3P(X,o,p,s,mA,dA,mB,dB,mC,dp,ds)               \
-	PUSH_3(X, DATAp, ds, ds, 0, o, (p), s, X##mC, (dp), \
-					       X##mB, (dB), \
-					       X##mA, (dA))
+#define PUSH_1P(X,o,p,s,mA,dp,ds)                       \
+	PUSH_1(X, DATAp, ds, 0, o, (p), s, X##mA, (dp))
+#define PUSH_2P(X,o,p,s,mA,dA,mB,dp,ds)                 \
+	PUSH_2(X, DATAp, ds, 0, o, (p), s, X##mB, (dp), \
+					   X##mA, (dA))
+#define PUSH_3P(X,o,p,s,mA,dA,mB,dB,mC,dp,ds)           \
+	PUSH_3(X, DATAp, ds, 0, o, (p), s, X##mC, (dp), \
+					   X##mB, (dB), \
+					   X##mA, (dA))
 
 #define PUSH_(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,IMPL,...) IMPL
 #define PUSH(A...) PUSH_(A, PUSH_10P, PUSH_10D,          \
-- 
2.27.0



