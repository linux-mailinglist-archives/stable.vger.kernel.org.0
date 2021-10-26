Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62F43AE5B
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 10:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhJZIwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 04:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhJZIwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 04:52:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C5EC061745;
        Tue, 26 Oct 2021 01:49:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so10143530edb.2;
        Tue, 26 Oct 2021 01:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=ijkv52IX5AhqwV9xhPLngnhvSsmuYcKxe3dbkxEPTMyWAkrP2TiIUUC55cvE7Y1p8S
         T5uU+YjLNXYZZD87ZniRkAt8yyVbA2T8eNp1JyrFnCEWjMYFT6+byP8bf8vIAQso0/Hn
         /43roQbeS5VRaB8BjoLn1/RQEuRg6a3n++siHyVElhyyxY5KBacIILnjaAmczzWjFZxg
         KThZtN3uJlDCm9u0UbPCWXJRcT0GjmqxlNSzvxKFb4vWpjmQ4joIVHbb3KboVvObQ4M8
         66fOaLnmLCcxDBe0BgzJpvswsRTdsY51Abge5ijWSNV00PRjfm/UJ7z+LHi6eZKtP87y
         l5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=TkMHQ/ETC7mVTxnVrS5NCjA0DQIZbo2rleQlcRByE4Yrra+6hFr/Fe7MFqDfGkxcXP
         ednAM8k78S6i25ExPkONcLXz7vfRrfUIfwHunJXGuin0UD2/slCcVAUz0JRKE58Cx1hJ
         OPZfw/t6ljenjpOohd0m0Mym1B7OsJNbf7tSi2s3RDdvqF48t7I9GBGvZ9/JYlXbah8E
         B7QxVh8zaIRHE1zf2+4FUDHVKRY7xTRRUkVq5CB4Mvq7W8sxcR7qAQNgtpmWr0ZKFgHX
         HlVwXpBqvGQVHnJhGQC5cVrwWRv7ASUOKHSOgdgOetb+Beg93m0LvGm0CnDon7RTE0Xs
         ozGw==
X-Gm-Message-State: AOAM533C5YRA7V4qBIHYVZxzV+oiLMs57k/lvU2dBlkNJ52HtrxDvkuT
        Sn6qkR3yzSaSpUFP/wWk+QY=
X-Google-Smtp-Source: ABdhPJxN69444mLpJ1L0DcXy5t+RCxB4J12A5h85HXz4pkiU+MeMNIMoBGa+Hb261/uraASrYZyUoA==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr29264292eje.112.1635238172637;
        Tue, 26 Oct 2021 01:49:32 -0700 (PDT)
Received: from md2k7s8c.ad001.siemens.net ([165.225.27.144])
        by smtp.gmail.com with ESMTPSA id o14sm1299525edc.60.2021.10.26.01.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 01:49:32 -0700 (PDT)
From:   Andreas Oetken <ennoerlangen@gmail.com>
X-Google-Original-From: Andreas Oetken <andreas.oetken@siemens-energy.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens-energy.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] drivers: mtd: Fixed breaking list in __mtd_del_partition.
Date:   Tue, 26 Oct 2021 10:49:19 +0200
Message-Id: <20211026084919.3476294-1-andreas.oetken@siemens-energy.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not the child partition should be removed from the partition list
but the partition itself. Otherwise the partition list gets broken
and any subsequent remove operations leads to a kernel panic.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/mtdpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 95d47422bbf20..5725818fa199f 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -313,7 +313,7 @@ static int __mtd_del_partition(struct mtd_info *mtd)
 	if (err)
 		return err;
 
-	list_del(&child->part.node);
+	list_del(&mtd->part.node);
 	free_partition(mtd);
 
 	return 0;
-- 
2.30.2

