Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCE176450
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 13:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfGZL1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 07:27:23 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41581 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfGZL1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 07:27:23 -0400
Received: by mail-lf1-f67.google.com with SMTP id 62so31971060lfa.8
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 04:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0nLERSg4u07PeLcbnJNifTNV6Ww1N/l/brHYj7jzWs=;
        b=tEZoMFkZNgKAf/ALc17jFdnG9AJ4QvVybihHJF/c2D6S8n5SsN+L+0XjTStbuw6X3M
         bhiLIFDVRKQDJwMjvY2YSPQW6Z18SiYmYS/N8UJts90hythAR+0+zfg+jIGnVVW2J+rP
         8qs/GJBVLpPG9EnfUtu3StUmEO0+4fVONMAQaypVDPNuMax6SLKkNRDcIq3OFdqbtPzf
         Bzga0dDpWlbFfGCELpmpkhKsiNExxgIJHjumwcK/j5zDry2aUVodOsIv/Y0GsUrnIZOY
         dk6ZmzAJmE/wTwCzcPDS8Gbt0fcwWyQ/djnGDjygEEDWDm/NHJI6XyPIxmmU41YyBfip
         K++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0nLERSg4u07PeLcbnJNifTNV6Ww1N/l/brHYj7jzWs=;
        b=uFB6KwK3smEimuWirUwa+0M0MnuHrv+y9GuUtDUwkDQlkhCykDS7khtmuxdnSzoZ8U
         lAkcxidvID6s0T9dVLWT5xzBflf7jtwFPH8N0/R4I/vYR5qiVaS+xfWm0Cs3Kt4ZFQMy
         0KbBOi8RiL9k72mHXcWhxwSFarM+Jx15iUl/SEk8fMObyKrbse06j+R0Z3xN9p9ykOfN
         tuczuvdrx3ETae24kz+2+7ofrArx1chgrs2LA9VhbcF4CxBAs2UK31xeLbk4JiMmKeje
         dB3kp+mqXVICoX5GQ0JIWUpt5m8LaHUjTwn63tuuVGoeZ7pxFZNLGFtZtkP5wXlqsWQd
         aTNA==
X-Gm-Message-State: APjAAAUGVLsZWiN0I84/HROiUi2ZqxfbzlrznGt8NodnBs1MsYD4G6/F
        QGBI1Ki+XJmyad/8qzZ4TDrLZQ==
X-Google-Smtp-Source: APXvYqzA4M9X20guHIBIplEQvEBB6Y95fjhGaemXWIsOmXfspEG/yh8Z8jnFK4oopjvXljlNC+Uf6w==
X-Received: by 2002:a19:234c:: with SMTP id j73mr1078425lfj.96.1564140441031;
        Fri, 26 Jul 2019 04:27:21 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id l22sm9910671ljc.4.2019.07.26.04.27.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 04:27:20 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] arm64: perf: Mark expected switch fall-through
Date:   Fri, 26 Jul 2019 13:27:16 +0200
Message-Id: <20190726112716.19104-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fall-through warnings was enabled by default, commit d93512ef0f0e
("Makefile: Globally enable fall-through warning"), the following
warnings was starting to show up:

../arch/arm64/kernel/hw_breakpoint.c: In function ‘hw_breakpoint_arch_parse’:
../arch/arm64/kernel/hw_breakpoint.c:540:7: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
    if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
       ^
../arch/arm64/kernel/hw_breakpoint.c:542:3: note: here
   case 2:
   ^~~~
../arch/arm64/kernel/hw_breakpoint.c:544:7: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
    if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
       ^
../arch/arm64/kernel/hw_breakpoint.c:546:3: note: here
   default:
   ^~~~~~~

Rework so that the compiler doesn't warn about fall-through. Rework so
the code looks like the arm code. Since the comment in the function
indicates taht this is supposed to behave the same way as arm32 because
it handles 32-bit tasks also.

Cc: stable@vger.kernel.org # v3.16+
Fixes: 6ee33c2712fc ("ARM: hw_breakpoint: correct and simplify alignment fixup code")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/arm64/kernel/hw_breakpoint.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index dceb84520948..ea616adf1cf1 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -535,14 +535,17 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 		case 0:
 			/* Aligned */
 			break;
-		case 1:
-			/* Allow single byte watchpoint. */
-			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
-				break;
 		case 2:
 			/* Allow halfword watchpoints and breakpoints. */
 			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
 				break;
+			/* Fall through */
+		case 1:
+		case 3:
+			/* Allow single byte watchpoint. */
+			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
+				break;
+			/* Fall through */
 		default:
 			return -EINVAL;
 		}
-- 
2.20.1

