Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76672B28BB
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 01:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404235AbfIMXAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 19:00:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42728 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404228AbfIMXAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 19:00:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id q14so33486623wrm.9
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 16:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=surgut.co.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XpllwYfF5lSHMIoJbJYCLYpW3JFisJtTY67sh/6aRNc=;
        b=PHiY0lJEqBr68xRX7iHkocC3884iiJGRZjDXkesl5XDoE6gfJdG0MURfNy3S3N+e9/
         YwUqFmcex0IoEYARFvSOBrvD1MwIJ0CS9uQm4MYDL0uVmggDR9hdMlXONuSnlmlYcPc3
         tEHDPEccjUva/MiAaZSPUvt8CPdB+410apBUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=XpllwYfF5lSHMIoJbJYCLYpW3JFisJtTY67sh/6aRNc=;
        b=bn2g9KlcSfOwzOcDK9IIl3Dyd6Ji4sUMF2An0/rEFmZZnm0SSfmG8Dvl10sgF9zn+v
         jcxG8Wg2jNgrwTStN3pStkjPrSQIKVs9lZRssAkfibvh2NP75mEHKWKjxSER/2OKdY3J
         ThVod3+dJHoJTR5+HXCDshchsJHG3IsPqCTlcqy0tt8iFKXvPBYjoPbYD53hR0Sv+ZNi
         gXzWpDbH9uM+ZGctdRkgxGRDQNWeGIfekbWC/6Z3xAUyjUrTp4r6yd+JahHn5J23Y0+Q
         M4DbVtfKIHUZlBRVWfYUWExddTOxEVLhMpTDR/5Msn5hUT8664Xn+tX5MuMqhVZZPpU5
         Tqog==
X-Gm-Message-State: APjAAAUlk8MQ//9swjqhvZ4fEU2BdNxJPPs4oMwIQjcB8bQAFo0mIcII
        JFiocpz62Mzr3aNNNOlKT4BEiw==
X-Google-Smtp-Source: APXvYqwwPYKtfFXx6P0Y8+Rs/jt0mKQcqYU9n0rHHKzHUWaPLEK7uv9we7f8MAYkAQVYcxIf4ctIiA==
X-Received: by 2002:a5d:52c8:: with SMTP id r8mr22179729wrv.256.1568415610456;
        Fri, 13 Sep 2019 16:00:10 -0700 (PDT)
Received: from localhost (9.a.8.f.7.f.e.f.f.f.2.3.f.4.a.1.1.4.e.1.c.6.e.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:de6c:1e41:1a4f:32ff:fef7:f8a9])
        by smtp.gmail.com with ESMTPSA id e9sm7197584wme.3.2019.09.13.16.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 16:00:09 -0700 (PDT)
From:   Dimitri John Ledkov <xnox@ubuntu.com>
To:     kernel-team@lists.ubuntu.com
Cc:     xnox@ubuntu.com, dimitri.ledkov@canonical.com,
        1843960@bugs.launchpad.net, Philipp Rudo <prudo@linux.ibm.com>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH][UNSTABLE][EOAN] UBUNTU: SAUCE: s390/sclp: Fix bit checked for has_sipl
Date:   Sat, 14 Sep 2019 00:00:02 +0100
Message-Id: <20190913230002.5058-1-xnox@ubuntu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

BugLink: https://bugs.launchpad.net/bugs/1843960

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org # 5.2+
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
(cherry picked from commit 4df9a82549cfed5b52da21e7d007b79b2ea1769a
 git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git)
Signed-off-by: Dimitri John Ledkov <xnox@ubuntu.com>
---
 drivers/s390/char/sclp_early.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index e71992a3c55f..cc5e84b80c69 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -40,7 +40,7 @@ static void __init sclp_early_facilities_detect(struct read_info_sccb *sccb)
 	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
-	sclp.has_sipl = !!(sccb->cbl & 0x02);
+	sclp.has_sipl = !!(sccb->cbl & 0x4000);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
 	if (sccb->fac91 & 0x40)
-- 
2.20.1

