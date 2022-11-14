Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F87A627D8D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiKNMUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiKNMUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:20:49 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5928523150
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:20:48 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 13so27931181ejn.3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=iF/YlGNlOzxHojJmqcX9ZAPxwT365ADtjmnShW81IrE=;
        b=N93gK/ST4ycT7bnx0m+f4iLT7pam3b3MwWSQyyseGWIj8X8lj/NK0bh0d8weSTCwRp
         P80t8q8nvbv5HJoAK0zRYXQqhjgSYwJlkkcdUq4Yq3O5yeizUWdayhcWpekfCFlTIkGi
         N/2Mtszd5Reir1QDCrrc812e4g8vTu820aCW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iF/YlGNlOzxHojJmqcX9ZAPxwT365ADtjmnShW81IrE=;
        b=scsDvLD5Iuor+snl64UgMFVSSnSx3L2bh23ydwPsrwdxF5wmmnQWlhVzEsEPQ6Uwp1
         fgD27v+ngoEJpPt9NnvVKwvhsgaUKM08q2dnaznDmxtXUOjwrUloZLZMbYEsFIaQKZgR
         1U1Kd0vsikXH6mwg0qbWeE1ufP2Yzaas7Ove6kpB6fLQCQ8R0AnDar5xjy3XyNK+YoQD
         414689Rrm5Cb/xvT68Q3TTTKt/vumKCsVRiZP30dwEp5TtNVvxm6a5q+wGZgkgCV6MKu
         B8Oh8KNhSlNxXj75YX2RPHSpIiZ5++Jyr/6vAPAWUKVbzP1CbRZcnWIBXWHTKeIFtgQV
         OIBw==
X-Gm-Message-State: ANoB5pkgG5G1EOLem7aIZjMNFp9C58XbUwyuu6Wg2zqxbf+NWDpGwhpT
        6mL2vXypnyGUnjws0DAKXjW5WA==
X-Google-Smtp-Source: AA0mqf66xA9SbnGazd1SrTNKzh8Bz+gR1a/Xa6wyapv+Q93JgPaKUp4OLwMydCrNdJu8YmjOxzc7HQ==
X-Received: by 2002:a17:906:58f:b0:7a0:b505:e8f9 with SMTP id 15-20020a170906058f00b007a0b505e8f9mr9746850ejn.216.1668428446880;
        Mon, 14 Nov 2022 04:20:46 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:c205:5c4e:7456:c8cc])
        by smtp.gmail.com with ESMTPSA id v19-20020aa7cd53000000b0045bd14e241csm4718483edw.76.2022.11.14.04.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 04:20:46 -0800 (PST)
Subject: [PATCH v6 0/1] i2c: Restore power status of device if probe fails
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIAJEycmMC/3XOwW7DIAwG4FepOJcKCBDoae8x9WDANEhtIsHKVFV593k9VsnJsuXvt1+sYS3Y2P
 nwYhV7aWWZqbHHA4sTzFfkJVHPlFBKSuF5UZH/QunIAf2YEWSWwTDaD9CQhwpznEjMj9uNhlNpP0t9
 vvO7pPK9FdUlFxzTKMD74L1IX3Gqy7087qelXtmFgrraxYqwGI0RIasEMW7gYRcPhJOzRsagg3Nbl/
 Uu1v9va+2ttsoNQ9jAZhcbwqS8tWN22cIHXtf1DzdyhHyeAQAA
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 14 Nov 2022 13:20:33 +0100
Message-Id: <20221109-i2c-waive-v6-0-bc059fb7e8fa@chromium.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>
Cc:     Hidenori Kobayashi <hidenorik@chromium.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org,
        Hidenori Kobayashi <hidenorik@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        linux-i2c@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d93f8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1988; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=L2z4HpXH9DdNsrfjX1MA37K4xpBLN/Vx7QbAH2x2Tow=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjcjKU+wE96oFP+E1L/znBajMc+rWgWh2lC9qT2KLu
 ooHproKJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY3IylAAKCRDRN9E+zzrEiFfXD/
 9aSU+FTnIj4O/dTi54CbmZg6cB+GaKM+6TC0Kwvm67bXNy5FMtbzHpembTUvaO0rXxSTfdZfx1GnWN
 6kA2SCsFxZb8ej2QLkd08mWSHiKoe+fvBnYzs/fHrmQBgepGc8b5higjQ+kf3Xg/u85VCfmi0NKs05
 tIzdv0txs2ZpQ7SvuG2IvsGcyvst1UwwZwAbptfXL/GSH61cbmCRiWP6rEI56e75MdV+D32Bl200Vj
 MGlVq/IHWiwy7KesuGOQNmvTHmcloRZFMEWYlXfxMYIlzShuOHO7e3zC/5XzAhtcfMq/sgWZ4iKAp+
 QGSeFHWwo8o1rFw0gPg+S6lNbYhGUrQzNE5CMAwwOA082IDCQ4p6g52kEd8iyaO3Nx17ocLesm6Pl4
 4iDP31eVzvSqEIG1tTVrE5QPvubMVdwhTciBkiwZxYX+h6+RshVUayWA2cKkj0eYm1xzqQ4tm1/6vM
 mmsXOScs5fW84JeEChxh/P/hIWmFiaJv8l0jXtJKEqStBSwSseZBBjl+jpAxaWhFXZxtfeO4q18L4c
 LZH7VXaX4AvdAxWxnpq/PMkyw7QlYNzDRZKsurmNcA8KcYkyjMnK2dGyHtqi9qIktjW57XC45bOLsk
 bokFrxUKKHnHIIlIGbWuRaN+Ypt0A8Q2RzLtuijxsmosOaVNZAVlY7+rl5+g==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have discovered that some power lines were always on even if the devices
on that power line was not used.

This happens because we failed to probe a device on the i2c bus, and the
ACPI Power Resource were never turned off.

This patch tries to fix this issue.

To: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hidenori Kobayashi <hidenorik@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
Changes in v6:
- Add Reviewed-by: Hidenori (Thanks!).
- Set device always off at remove.
- Link to v5: https://lore.kernel.org/r/20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org

Changes in v5:
- Add Cc: stable
- Add Reviewed-by Sakary (Thanks!).
- Renamed turn-off as power-off, in the name of consistency (Thanks Sergey!)
- Link to v4: https://lore.kernel.org/r/20221109-i2c-waive-v4-0-e4496462833b@chromium.org

Changes in v4:
- Rename full_power to do_power_on.
- Link to v3: https://lore.kernel.org/r/20221109-i2c-waive-v3-0-d8651cb4b88d@chromium.org

Changes in v3:
- Introduce full_power variable to make more clear what we are doing.
- Link to v2: https://lore.kernel.org/r/20221109-i2c-waive-v2-0-07550bf2dacc@chromium.org

Changes in v2:
- Cover also device remove
- Link to v1: https://lore.kernel.org/r/20221109-i2c-waive-v1-0-ed70a99b990d@chromium.org

---
Ricardo Ribalda (1):
      i2c: Restore initial power state if probe fails

 drivers/i2c/i2c-core-base.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
---
base-commit: f141df371335645ce29a87d9683a3f79fba7fd67
change-id: 20221109-i2c-waive-ae97fea1f1b5

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
