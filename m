Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A403B21EB
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFWUmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFWUmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:42:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC16C0613A2
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g4so2207731pjk.0
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u4Wq1GvZOIjkJl+9Sb3C5gljEm3KHr7dyOq9Nh1kENs=;
        b=XFDgiA11BlqOZ/s5qZFq8MJlNVnoxfK5CVNFc1wQ+SamMB7fnUnMUUgxxrmEowQujn
         tChT4z4jt7Dod0HMLYvUcQ5smxaJewfSB0bx0ip0qzErWVrXCz873TRrhXNwq1WgYPh2
         J+XbSmnSUcAJVg4aI04DD6Q+X3GDjnShhd/c0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u4Wq1GvZOIjkJl+9Sb3C5gljEm3KHr7dyOq9Nh1kENs=;
        b=gKmbhsX9FxUI77SxZ51opbpCviFbtIHsjhl0BKXq/S9flLiaUVLGUQ6ph5Ai3qbt58
         cxYUszMK06orzCqD0k93pdnNklK6jUxBKEU3f8FRgBD1+5rlitLziWrpEiIwWPwf3OxS
         7Ws2lRUFMGSTCZ532ZmtfIHOLexmQShTu9TDhezCeXRuEGFhANMvzYoixqxCMYcSWeN+
         aXO3RfRKbiPVwPN+btg0JiEcXUafMaBS8HTYAdvpEI6u7C5HLc0emtV/noXP33RdbUEf
         QijqN3NlKSCc3YXJFULq4qc7zmIaC1GubdkZaNC17OpSzAaZ/zHbpVSQtoqlCLsnNhWx
         XyEw==
X-Gm-Message-State: AOAM531qMnQpxQHag6VELnoZIprD7NGPAu/KAKPAarXwJ4cLGyrSYeqo
        rNpjtCl0I9y2cUbG1l82xT+3Hg==
X-Google-Smtp-Source: ABdhPJwaRWpJV0oWeW72e7h8k40qI2L5xwkI1YI4az/SGTiOAfGJgoe0c1chphXJsHy1G3dgvqSphQ==
X-Received: by 2002:a17:90b:33c6:: with SMTP id lk6mr11521139pjb.6.1624480790156;
        Wed, 23 Jun 2021 13:39:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y39sm644828pfa.119.2021.06.23.13.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:39:48 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 6/9] lkdtm: Enable DOUBLE_FAULT on all architectures
Date:   Wed, 23 Jun 2021 13:39:33 -0700
Message-Id: <20210623203936.3151093-7-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623203936.3151093-1-keescook@chromium.org>
References: <20210623203936.3151093-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; h=from:subject; bh=QfRkdXxwpbuwCkU2UJjVNaH2YmtWo4KLL9a8FrnsAOg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBg05wGyZpmYK4bGS71//ZU4B8K/PYzebIRU4wL+IO5 4o7WiviJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYNOcBgAKCRCJcvTf3G3AJirXD/ 9ZdemyXHPgslPcJgT1bRYzqMUwNSL97PXErHRLjYgDkmORiRviHSACWq7BdCf9JHLl+jBeflXOPLZQ AbximpuX/FoB9FKsrHW7PAqWDi25hrM8UFNh/Qru8hNicn5W1byfOBVo36lG7+/+4QKrrpMorYPEsA om3e7YlG5GsVrovAHUHMNWJ5WMcPZAvZJb0D7ESVcVjxhzmYoqccFGJIJpbNQU+MnoaLTs9Iu3PRuV 3q3nzAZIENHOUMQTihH7jEog+oudsw6O4yKRlYsP1+dKYm8HI2+1PBjkUcEx4gmBuvcCOfyaYseu0j 1bdozFFNR+T/Ji8v5ry2S6p/fsoMQTItw57w7xCT/tqZHcpMgddcxy+/QcdE5VnE0oW4Zc3ySiZWZB xfyGeUzLdRHPzcKdIYqflNCMw1VQSUoQNoV/Z6ImPROiSRYk+w0173YAlUNgSjTsP2CV96lhqelPSi RtjbNSRaB0FmDCi5+P0jaXa3lKOxnR4XAOyunOMRds0qwSeGiPWU+a8MWj1dWlDzZWoAgiqHO32CQK 62fMew6TMBnOwvUSFXRq7J8zdEMNoiTO+jF+UhnChwpGrid6O+oLnFe/cjuzWYp5rICy/d03T4yBKD mSq+hoWr7vvnEQpgPh92VHycKploZOSBWMAcAaolOJlskbK4P3hc9IVdTRog==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Where feasible, I prefer to have all tests visible on all architectures,
but to have them wired to XFAIL. DOUBLE_FAIL was set up to XFAIL, but
wasn't actually being added to the test list.

Fixes: cea23efb4de2 ("lkdtm/bugs: Make double-fault test always available")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 645b31e98c77..2c89fc18669f 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -178,9 +178,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(STACKLEAK_ERASING),
 	CRASHTYPE(CFI_FORWARD_PROTO),
 	CRASHTYPE(FORTIFIED_STRSCPY),
-#ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
-#endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	CRASHTYPE(PPC_SLB_MULTIHIT),
 #endif
-- 
2.30.2

