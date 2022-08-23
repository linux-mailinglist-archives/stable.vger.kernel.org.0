Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD459E67D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiHWQC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244277AbiHWQAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:00:42 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1508923DF17;
        Tue, 23 Aug 2022 05:12:10 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so7616864wms.5;
        Tue, 23 Aug 2022 05:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Z3jS9cDd3S+epLGnpe5pOc0ThMjaHgjznjX+2D3u/4c=;
        b=n9EtjlSKfSV+gn+H9SwZMXN73r1eEYgb1NqxTc2GgJzuTbX7WFo4Fjg2dZGqKhsnHo
         9QBVaX6AmpLDSmzsSzGey9d3h/v8aiAfJNR7uPOZ8JO3M0oq2oPB5wRzJduwInm1O9OJ
         EJbLFZE2aVTOeuDLkCWiBcf7gnnwmR9vzrjcR04clLazJVnAvAlXnJuC5rsAeaD4V2nj
         W2jqpSoAQ4nBFS2/OFYcev1Wd6hnnqBivQsVKMZouGSgW7qVjIZspKW3JTT+X6Ka0oiL
         4qoRcxKtxaX/PjgVuP7eRcCmw8iw+veYQWAUuSF6H3Nvkc6y5yQzVuUAgdey2fj8kzNc
         PM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Z3jS9cDd3S+epLGnpe5pOc0ThMjaHgjznjX+2D3u/4c=;
        b=KdWtNQKP3ThcMtHLANue2UzJAOMScqkWKJ3+Vd52V9bDVdpNUZqHQo5F8s0+8juSc3
         IvPunziJEqI4q+m8llBvhdqUTwLPCRMsHdu0pGuqOWwhHpKUEyWkSEam9LuZHNoMopzZ
         mBp8vYuJCCd0VB0q4yIqaqu2RMJN0yIlO502Kgvt+eu+tG8+pBVCDrwXIWGaCnYERswb
         zElymteCKl0gdGxafEhcUrby4y6J07FFy7dgsVYXwaFTbbfrkuGq3bxLeyHzMrA42c1D
         RNcq9j+HFNxChG2Z/oBV3aw8jRnCAnEK3jpaL24rjPY9hmU+XJrkni9QJgaWThYLfErM
         EAkg==
X-Gm-Message-State: ACgBeo01FTpn3f9ycIn31/xQagXZb2CkzzYjgj2XLNemJARI31edAX9e
        BUxsEssJ+EoyuOPDSfIKDCc=
X-Google-Smtp-Source: AA6agR7P7GVOlr1FjIyCJFQdTjBjUUb9Re01MeZl/ZF5E65SoCa+GuB6SAY+xdXUwY2mxguF+ZNv1w==
X-Received: by 2002:a05:600c:1f11:b0:3a5:3df9:4859 with SMTP id bd17-20020a05600c1f1100b003a53df94859mr1942884wmb.175.1661256705272;
        Tue, 23 Aug 2022 05:11:45 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 5.10 v2 2/6] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Tue, 23 Aug 2022 15:11:32 +0300
Message-Id: <20220823121136.1806820-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 upstream.

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d973350d5946..103fa8381e7d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1689,7 +1689,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
-- 
2.25.1

