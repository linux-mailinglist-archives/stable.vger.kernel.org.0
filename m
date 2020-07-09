Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2672A219FC0
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGIMMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 08:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgGIMMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 08:12:47 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DBDC061A0B
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 05:12:46 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k6so1806278ili.6
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 05:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aAsyC6EfytFSxSIdp3SNQ9kbGtI25wlreZ+D59wjJYY=;
        b=rNFiEIZvyEZiecfzjVG7Gx7oBT/K+qfVHNVKm2TuxoJ6cbOGtore8+tKW8w2sqn5+3
         3rJkd3nAJ3/BejXuTZPhj5WiowtiBuZdC1fEH4TNJ1wsJ8Jif5vhRqYgQUCsv3mb9PDs
         Oa3JXWvpr/JUZPoJXP0nAxWsTlGK5+Ycjq3902ulQO9hGCexwicV+cP1JGShC9C4SFoU
         JS9Fjh8/HPG2cnAzEfDNaz4zUx0+srVGvq+cLSBs9ECx3WvdARE3kknViugkWvaFyKyB
         CC7C9gXODap0wXuIcutZO+tOXKIXEba+ScU6BfiYxWr0giJMbnD4gsle6DwFGVoKkVRi
         AV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aAsyC6EfytFSxSIdp3SNQ9kbGtI25wlreZ+D59wjJYY=;
        b=Q3Hn9snQrlSDIgeongF89J/+gyp4go7gSHdJK5YtihALNB3NknDUzYnDs62YBZyGP5
         0tt1XnRbvNUO5lIhbX1r6J4CD1dYFf6HGrPbtqmRooHQJjSH4VQyh5dqQWCaFnxsmg7t
         mnJIfyzrGiclrmJmkup0y9dniufFppaCIbN2qT+fapVLbBJuDMfTb9vYYGjNiq7h4ia+
         Q/NAwVA+V+iYdjZ9ouwGmwMasaXdF0SKTYxgiQG/DaKZu10TTpCir2/N9XRzIWVKk9gd
         QNUO3cw8TGmAA/K4P++KANOevLr6bLK8A/ZbbKvYlm8jgZJyH8VLNb6NTzy/RhjPn/Er
         n3Yg==
X-Gm-Message-State: AOAM533hWcEfgHPUMj428FcFjZJ0cfdxAO1BDiZ5MoRIyGob0n/VsKIg
        mcAymsQ3NYPh26zWebEHNzEwbpt+
X-Google-Smtp-Source: ABdhPJwf9NTEWfE5OQjA6nSRfIyxfmKpyFs1X6fS1mGcbIDr96N5FBcegctCckcS7qsQF8nUO0uNwA==
X-Received: by 2002:a92:da4c:: with SMTP id p12mr17809787ilq.142.1594296765961;
        Thu, 09 Jul 2020 05:12:45 -0700 (PDT)
Received: from aford-IdeaCentre-A730.lan (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id i188sm2096131ioa.33.2020.07.09.05.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 05:12:45 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     stable@vger.kernel.org
Cc:     tomi.valkeinen@ti.com, aford@beaconembedded.com,
        Adam Ford <aford173@gmail.com>
Subject: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Date:   Thu,  9 Jul 2020 07:12:32 -0500
Message-Id: <20200709121232.9827-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There appears to be a timing issue where using a divider of 32 breaks
the DSS for OMAP36xx despite the TRM stating 32 is a valid
number.  Through experimentation, it appears that 31 works.

This same fix was issued for kernels 4.5+.  However, between
kernels 4.4 and 4.5, the directory structure was changed when the
dss directory was moved inside the omapfb directory. That broke the
patch on kernels older than 4.5, because it didn't permit the patch
to apply cleanly for 4.4 and older.

A similar patch was applied to the 3.16 kernel already, but not to 4.4.
Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
on the 3.16 stable branch with notes from Ben about the path change.

Since this was applied for 3.16 already, this patch is for kernels
3.17 through 4.4 only.

Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")

Cc: <stable@vger.kernel.org> #3.17 - 4.4
CC: <tomi.valkeinen@ti.com>
Signed-off-by: Adam Ford <aford173@gmail.com>

diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
index 9200a8668b49..a57c3a5f4bf8 100644
--- a/drivers/video/fbdev/omap2/dss/dss.c
+++ b/drivers/video/fbdev/omap2/dss/dss.c
@@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
-- 
2.25.1

