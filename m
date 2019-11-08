Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9533FF58A2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfKHUg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:36:56 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:50269 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbfKHUg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:36:56 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mi23L-1hxwm536Mz-00e7qK; Fri, 08 Nov 2019 21:36:36 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Bamvor Jian Zhang <bamv2005@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/8] lp: fix sparc64 LPSETTIMEOUT ioctl
Date:   Fri,  8 Nov 2019 21:34:29 +0100
Message-Id: <20191108203435.112759-7-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108203435.112759-1-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AdGIzk8C/keCLr5gehPESKcLmoKBfAibkexFmJLNk/J2fjrWvfQ
 8MAcq+hyhFCKe2NGkMCKC8E6hOh4EiIOzxoFMQpf3a/A02gkKmMm67Uoa2gD8xG2+2utJwY
 cYeiQr+CRTPH4nv3P5X2WlQL+CA52ot2f9Dezuje1gFc+nbrE7YWv6SVCXd9j58mgdTJ/N8
 lsNRivF1GfWhv/gGAwK9w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mRuBUasDfOU=:flVrvYp7E8yox4TyMBaI4z
 UYkgcoF1o+2SBVnju+MHHn+yfHpZAqQtuXlQTecwl9wHeKYJ5TKKRtsJp+MjU/UBX2Flde831
 vQ2JCT18G9LprQqZvqVuf4UDC1voQ0EBV3a9CMXWylrhmSp9RSs22NgQ81ZP3En5UQHevX3mk
 LmMHcii40IfdAJYmPPAazrcqMu+GOhqXbxRvAYh0UHNbOnRr/zEoYrS0GICHJyCQY0ZpHYC50
 rm3Uh1TN7AMYsv25mgUOHlLrPKvHTMb8TSbGpEUmp0Uz9loju/Brl6fG8quDJdD1XkmjrnC5X
 AZjfBYqEYRsezTHUDuV/xGgkauUXMNS2dh/lgVOnOeWi2A6BPFhKhZnIvbFIlP4rFkEN2MuCM
 sZINyLUT0UxJxOm4t+9chCQOxmB9bMYXbQNdzGSUQ5EVgxrX/dNuZpw7+OACH3P6K1VZNjMIM
 HA4Amu8XFQR/oU90pQiRRVgXIGt5tqM4AFVweZxqfIeRkHDXdyK3QiayQWG/sI/sfKTB12JuY
 LKVpokywzACi1TaoB//PcySul25uWn2O8/yv37Xm5tLRfiEU3xu8jUWNWW5MeFPrwdT/rDVsT
 e3BdROHlQi0tIIxlCkCRArDCICN+wi3VseR+UOMgHdhHilaRIzzHsJYju2NcpnYBkOyyya92t
 wgt9ECTg4ig1UujjAKyOIHbwkWtrk6/mLA+UqilOT6OIQYbiw5CF+VZdRBUth6InGsEZPEqtp
 jrbEV7NDpXtGm/2uEgZ3AmDrcNhNFCDb0ZGuoldCn9CkMD7AFX2HLt1ZCHDsq0mE0t41Yvkfr
 XbC093GVzuzGlrvVN1hd96kwe2m/Yu6WzqFkb7QBzmbK/8bDu4Ct3AJ3cwGn+Ye31SkWwYQte
 0v+0lW0dTx0/GuOAc8Ow==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The layout of struct timeval is different on sparc64 from
anything else, and the patch I did long ago failed to take
this into account.

Change it now to handle sparc64 user space correctly again.

Quite likely nobody cares about parallel ports on sparc64,
but there is no reason not to fix it.

Cc: stable@vger.kernel.org
Fixes: 9a450484089d ("lp: support 64-bit time_t user space")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/lp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 7c9269e3477a..bd95aba1f9fe 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -713,6 +713,10 @@ static int lp_set_timeout64(unsigned int minor, void __user *arg)
 	if (copy_from_user(karg, arg, sizeof(karg)))
 		return -EFAULT;
 
+	/* sparc64 suseconds_t is 32-bit only */
+	if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
+		karg[1] >>= 32;
+
 	return lp_set_timeout(minor, karg[0], karg[1]);
 }
 
-- 
2.20.0

