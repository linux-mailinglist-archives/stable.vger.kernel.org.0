Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85E03FE925
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 08:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhIBGMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 02:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhIBGMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 02:12:09 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6453CC061575;
        Wed,  1 Sep 2021 23:11:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j16so71797pfc.2;
        Wed, 01 Sep 2021 23:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Re97f8GY8el/iMPEVsgvs7BOVwiJIsCI6/eriuguFs=;
        b=j+slSkBVQcYRtdw95G6g19jR/rB/V0QtgWg0gDoNculxcUhKBluCdvr9+ENgca+loQ
         6SsF1yA6cwrlfTcWS3PfI7Da1FWj2a+ya4nsSnBgAmkZLvJw1bUCAXNgP+CMA/r2adaF
         CKtELkqVFzd2sYiVNyDAKUbklFDb3kQQLdsp2cfuFtREKOS04Gi0mxUrxKcRyoXL3nOz
         3AKCvoDj7qSUIwi3lNXZdN9WeqQqpb/R2/IiCH/Bjapl1xn7qOd4jC8+viZW/dLciMvv
         B7to9pR2xfCaGk29uvlFFufCc/w+a3YLT71VG0apS6x7UpY3eEQpfIR+HVEZ2vwupSNA
         HS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Re97f8GY8el/iMPEVsgvs7BOVwiJIsCI6/eriuguFs=;
        b=FE0bLKa39X1OPhku4k3yQ8lYKY0zBywT/2qnkOB+FUNM70mgq9lSU/mQeTAkgUbwlS
         PGtWVBnfUTGmtDJ3DN1hgl651d1raBlqZpn53QNFAjm991Q3Z405WT8VhKGQrJpqD38w
         Ex5xG1vfnUt8XYVlot2dWF3E2VSg134HcotR5rO3W1QkldB0HFZnBM784AoHhJXeZmYw
         8MgzJqj6yu7Q+qw2IgFAcDdyKgxMIkeqtJX9qNRZFznUuCWJ57+Hk9WStEK86jJIr9eO
         eisx3sDc3/3S1X4pzWqG52Nw7GjIgocg/ObX+bluH8bdE1oQOSXMOPB84moV5rEvmSuI
         weHw==
X-Gm-Message-State: AOAM530SvBvE35zoofizvr5ulKi2zhRoeBrwQ9WpfRPATproVtsISIhT
        fvL8M9361HXohllNcMj5n7xfmd3rQiinrmDaYok=
X-Google-Smtp-Source: ABdhPJxvDl67Vw7WqN2iDOfF3qLz5rISiJX7ErxXYDu87qoPUWHnwS86fuE072+LdWIKRC49er4+RQ==
X-Received: by 2002:aa7:9ae9:0:b0:3f5:e1a7:db23 with SMTP id y9-20020aa79ae9000000b003f5e1a7db23mr1801940pfp.42.1630563070572;
        Wed, 01 Sep 2021 23:11:10 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.48])
        by smtp.gmail.com with ESMTPSA id 10sm914446pgd.12.2021.09.01.23.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 23:11:10 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        George Kennedy <george.kennedy@oracle.com>,
        syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19] fbmem: add margin check to fb_check_caps()
Date:   Thu,  2 Sep 2021 14:10:48 +0800
Message-Id: <20210902061048.1703559-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a49145acfb975d921464b84fe00279f99827d816 ]

A fb_ioctl() FBIOPUT_VSCREENINFO call with invalid xres setting
or yres setting in struct fb_var_screeninfo will result in a
KASAN: vmalloc-out-of-bounds failure in bitfill_aligned() as
the margins are being cleared. The margins are cleared in
chunks and if the xres setting or yres setting is a value of
zero upto the chunk size, the failure will occur.

Add a margin check to validate xres and yres settings.

Note that, this patch needs special handling to backport it to linux
kernel 4.19, 4.14, 4.9, 4.4.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dhaval Giani <dhaval.giani@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1594149963-13801-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 84845275dbef..de04c097d67c 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -991,6 +991,10 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 			goto done;
 		}
 
+		/* bitfill_aligned() assumes that it's at least 8x8 */
+		if (var->xres < 8 || var->yres < 8)
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)
-- 
2.25.1

