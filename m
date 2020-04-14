Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CD91A78C5
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438488AbgDNKtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438467AbgDNKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:49:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11822C061A0E;
        Tue, 14 Apr 2020 03:39:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d27so4513035wra.1;
        Tue, 14 Apr 2020 03:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oxvQlRsffaRa1NodizK6Br3j1HOkDXlCeGnv2LmuSWI=;
        b=lj/uGfhbz4egaV+UnAbsxUn1CLKh0qjYU2+LwcluDaE8/HfN9lqui58xiPaVTPNlEz
         Tvrw9UOSoPYH94mDVBxiTXwWkip64+s0qhXnAOwMsi7rDhVCIMwK2MjpjW+I3q0V4dZL
         FET3+ROtaDQoSLv/8v85tZsgNFsIBXHBbuh7L3zMzGQHuiLitSWfn6s9wM/sJ7ynG/Wq
         TKy5D3v6NDGPMWbnv2i5MjW9E/UCetI9K0pN3zK9nO+HtVabtpJcclkn4wLFvBFsuBcP
         YFNFmKF5JAfBAWyJgtEBnBWORX7l7/G1NCtv/tRbMwKZQFwIdWO2gy/2IdLJVrk8gCVk
         kyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oxvQlRsffaRa1NodizK6Br3j1HOkDXlCeGnv2LmuSWI=;
        b=HI45Xfwfrl8dNovoLsrSN1g80pks8KnI3GipEhVBadBucKlhP37+pSmonnf1KFqv5X
         zKZ/Rde283oZav6Xth5552L04tRkQqOC92RFHkhgfAaPb0icx+GcRCL6NLXZoBYxHjJx
         951HSdTLGX2JoTmuyr2aKRc0XiEOdD4LDX9KddcspL8zGK5D8nVlI7fqyQQzhW6jQ+z6
         LdoNY6y74g738xB93vgyLUBbGPKSpQBhjP9liKCxIisoIxUO01mF5CU8FEr7UmjL+Abj
         3xUZ8jTk+H9cWUK6uE512taN7ApD+OL6v+ubtM4MushshxW7ILUE55lM2v8iRocJqaWh
         0iag==
X-Gm-Message-State: AGi0PuZRKZkLo4EmMXo+BfTkjFdbzp82VzEWOkjP3Nlh8KI8ec/O3PAQ
        MxOJ5ZyZnzoTBOXCz77KWQozD5r0
X-Google-Smtp-Source: APiQypICmu9fPjO1czZST40gVi6c2FnDtlUHGNYPi09uSumvOoAMgSrHl5Jd30B+iwbGMGkCUx5VVQ==
X-Received: by 2002:adf:82b1:: with SMTP id 46mr16032416wrc.44.1586860765578;
        Tue, 14 Apr 2020 03:39:25 -0700 (PDT)
Received: from [192.168.43.18] (94.197.121.244.threembb.co.uk. [94.197.121.244])
        by smtp.gmail.com with ESMTPSA id u17sm20301174wra.63.2020.04.14.03.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 03:39:25 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: Power save stop wake_up_count wrap around.
Message-ID: <fce47bb5-7ca6-7671-5094-5c6107302f2b@gmail.com>
Date:   Tue, 14 Apr 2020 11:39:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

conf.listen_interval can sometimes be zero causing wake_up_count
to wrap around up to many beacons too late causing
CTRL-EVENT-BEACON-LOSS as in.

wpa_supplicant[795]: message repeated 45 times: [..CTRL-EVENT-BEACON-LOSS ]

Fixes: 43c93d9bf5e2 ("staging: vt6656: implement power saving code.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index eae211e5860f..91b62c3dff7b 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -207,7 +207,8 @@ static void vnt_int_process_data(struct vnt_private *priv)
 				priv->wake_up_count =
 					priv->hw->conf.listen_interval;
 
-			--priv->wake_up_count;
+			if (priv->wake_up_count)
+				--priv->wake_up_count;
 
 			/* Turn on wake up to listen next beacon */
 			if (priv->wake_up_count == 1)
-- 
2.25.1
