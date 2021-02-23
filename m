Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7C323202
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 21:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhBWUWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 15:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbhBWUWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 15:22:51 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F74C061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:22:11 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f137so3600594wmf.3
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BkPOxcgjrqWtZmRCdmfyLFJG8McoAwV+9oi6TjuwMnk=;
        b=lOhh30k3IPB0EYx/+U2Vv6mcH2hBymbtvUTpp9/QrZrlQ7ppB8MG5NMjBLRzjKJq0E
         +32cam6DtdrI80VWXUZNVzpN+36sJUVnJHGp8ZG+waNKvjfWoSwrZoV5l26Uf0sUYMfK
         PJyLodzBJhhzqv1K2eJhcdRj7rk7N7286ky4Fjef3FDHCqpdTF31bYkraTvpPH++FNa4
         1VFSjnkVzVJDl2aM4nYnk14FDKHna+I7X7LUumWOzuRO9Wja8LRva563vb/LFm2Lh77V
         fprRxQ9h8X26GoROr4D7OUk3TAXncYfDHztQ3zNyUmowMoGAYVBfvGBz6op5WA0Iz3fT
         vHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkPOxcgjrqWtZmRCdmfyLFJG8McoAwV+9oi6TjuwMnk=;
        b=rw3D2Ew1uBvL7r7W3Mx9YZsF+xSEbkZeGSjwhj3UF2x8DakuR9ZsD5sdNxIA1iI9f4
         nql63AVo4bQLj7nUvRtsg05kQ+Qchtjcmtq3tNZ4Afl+g7a25ahHm23IOwR1QMpn5BFG
         o8ElO0LH09JTmgtZfUv3JkBLTt346BQw4gpsaSb+rQIbTWFh4wXSjaslKvWertMruVlK
         UNRHVpnXgUPsl6W6ii92v3SitwViqN6cPZ/L9l6GoWFjqb65149f+Lc7kmUEe94HyKkr
         NDOgmtlmst9yQ3cEEXFYu7x155yieaVdC9tzklTH0gIqpwmKvN6EL3EO0cYoFul3DKNK
         oCiQ==
X-Gm-Message-State: AOAM533RjC49piOGM9u4Ns8q2EijAE0TZWrFvfuymIeiStjhiQOCgblx
        dNJWeUfRHnoGbidYH+PL7BY=
X-Google-Smtp-Source: ABdhPJw1gZf5OWCT9QjMn2XBExF7dqGlffcNklaIuAYRmwYLCtHi8+TmvmO7NtM2yVt/Y0W6TGl47g==
X-Received: by 2002:a05:600c:4f86:: with SMTP id n6mr479726wmq.22.1614111729857;
        Tue, 23 Feb 2021 12:22:09 -0800 (PST)
Received: from merlot.mazyland.net (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.googlemail.com with ESMTPSA id w4sm3718072wmc.13.2021.02.23.12.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 12:22:09 -0800 (PST)
From:   Milan Broz <gmazyland@gmail.com>
To:     dm-devel@redhat.com
Cc:     mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] dm-bufio: subtract the number of initial sectors in dm_bufio_get_device_size
Date:   Tue, 23 Feb 2021 21:21:20 +0100
Message-Id: <20210223202121.898736-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222211528.848441-1-gmazyland@gmail.com>
References: <20210222211528.848441-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

dm_bufio_get_device_size returns returns the device size in blocks. Before
returning the value, we must subtract the nubmer of starting sectors. The
number of starting sectos may not be divisible by block size.

Note that currently, no target is using dm_bufio_set_sector_offset and
dm_bufio_get_device_size simultaneously, so this patch has no effect.
However, an upcoming patch that fixes dm-verity-fec needs this change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-bufio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index fce4cbf9529d..50f3e673729c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1526,6 +1526,10 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_size);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (s >= c->start)
+		s -= c->start;
+	else
+		s = 0;
 	if (likely(c->sectors_per_block_bits >= 0))
 		s >>= c->sectors_per_block_bits;
 	else
-- 
2.30.1

