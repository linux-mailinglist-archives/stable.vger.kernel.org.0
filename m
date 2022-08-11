Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703AF59043B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiHKQhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239185AbiHKQg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:36:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A349AFEE;
        Thu, 11 Aug 2022 09:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E06CBCE22BD;
        Thu, 11 Aug 2022 16:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4886DC433D6;
        Thu, 11 Aug 2022 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234307;
        bh=hNnG/QF449VVgko0ZeoXmHgr1IPIPHXrWVvntaAq3ww=;
        h=From:To:Cc:Subject:Date:From;
        b=PzIvCj4HqBp1jS7EUWfWuySFGm50cox/A+WSth4svMReKh8U2DqgQz5FiS6xOqFA4
         M67J6gt8tNM2UXXBBu68QIvDJ/ad+pj/6EA3FbnB6MSSZAwZtmK62efzP/mG66KXpa
         KWarhoch0jI7ICTWopVHYKMJhJ1iHQhbIL4c2UqozbdeGD2rPKWHDiKjm8Z+A66RSa
         /xE0NDawDiwDUHIg/NHSz577eWzrIR0f/DNeVgwM1zWJ3FdOinBtps2xAE6mWBp1A9
         3xgp+nR57DMMxJQL8eiBjKb3e9QMi37gHFAtNxOOlA2fSZUfGZWxxaB+ocWOYrInVx
         MRGaRA+q/zLkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 01/12] drm/r128: Fix undefined behavior due to shift overflowing the constant
Date:   Thu, 11 Aug 2022 12:11:27 -0400
Message-Id: <20220811161144.1543598-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 6556551f8848f98eff356c8aacae42c8dd65b2df ]

Fix:

  drivers/gpu/drm/r128/r128_cce.c: In function ‘r128_do_init_cce’:
  drivers/gpu/drm/r128/r128_cce.c:417:2: error: case label does not reduce to an integer constant
    case R128_PM4_64BM_64VCBM_64INDBM:
    ^~~~
  drivers/gpu/drm/r128/r128_cce.c:418:2: error: case label does not reduce to an integer constant
    case R128_PM4_64PIO_64VCPIO_64INDPIO:
    ^~~~

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405151517.29753-5-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/r128/r128_drv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 09143b840482..6553a855a176 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -289,8 +289,8 @@ extern long r128_compat_ioctl(struct file *filp, unsigned int cmd,
 #	define R128_PM4_64PIO_128INDBM		(5  << 28)
 #	define R128_PM4_64BM_128INDBM		(6  << 28)
 #	define R128_PM4_64PIO_64VCBM_64INDBM	(7  << 28)
-#	define R128_PM4_64BM_64VCBM_64INDBM	(8  << 28)
-#	define R128_PM4_64PIO_64VCPIO_64INDPIO	(15 << 28)
+#	define R128_PM4_64BM_64VCBM_64INDBM	(8U  << 28)
+#	define R128_PM4_64PIO_64VCPIO_64INDPIO	(15U << 28)
 #	define R128_PM4_BUFFER_CNTL_NOUPDATE	(1  << 27)
 
 #define R128_PM4_BUFFER_WM_CNTL		0x0708
-- 
2.35.1

