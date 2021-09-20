Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E032411162
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhITIyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhITIyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01664601FF;
        Mon, 20 Sep 2021 08:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632127976;
        bh=EDK37GqX0xoiUriuEmMuWyz7QBA3IcBixQQlXPKUfn8=;
        h=Subject:To:Cc:From:Date:From;
        b=kXNCJFkkW9/JXxcQt0uQeWMhb/UNMjUsR8ar/Nkw5hDIzxi+S9v8cpPiwi4bVvQUR
         bwIiihYKcbVebN/5XawG6jRoDAiGPB6F00nJJg2uw9gwvyWxMxUimVYaD36iYzucFk
         d2ShQoJ+LFg3nmG0DJ0HvZ+cCPVLydEXxzwSaVH8=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Drop inline from" failed to apply to 5.10-stable tree
To:     mdaenzer@redhat.com, alexander.deucher@amd.com, lyude@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:52:54 +0200
Message-ID: <1632127974199214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 114518ff3b30a3f0611f384fb58e0a968fdf7f5e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>
Date: Thu, 9 Sep 2021 18:56:28 +0200
Subject: [PATCH] drm/amdgpu: Drop inline from
 amdgpu_ras_eeprom_max_record_count
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This was unusual; normally, inline functions are declared static as
well, and defined in a header file if used by multiple compilation
units. The latter would be more involved in this case, so just drop
the inline declaration for now.

Fixes compile failure building for ppc64le on RHEL 8:

In file included from ../drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h:32,
                 from ../drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:33:
../drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c: In function ‘amdgpu_ras_recovery_init’:
../drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.h:90:17: error: inlining failed in call
 to ‘always_inline’ ‘amdgpu_ras_eeprom_max_record_count’: function body not available
   90 | inline uint32_t amdgpu_ras_eeprom_max_record_count(void);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1985:34: note: called from here
 1985 |         max_eeprom_records_len = amdgpu_ras_eeprom_max_record_count();
      |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: c84d46707ebb "drm/amdgpu: validate bad page threshold in ras(v3)"
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index dc44c946a244..98732518543e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -757,7 +757,7 @@ int amdgpu_ras_eeprom_read(struct amdgpu_ras_eeprom_control *control,
 	return res;
 }
 
-inline uint32_t amdgpu_ras_eeprom_max_record_count(void)
+uint32_t amdgpu_ras_eeprom_max_record_count(void)
 {
 	return RAS_MAX_RECORD_COUNT;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.h
index f95fc61b3021..6bb00578bfbb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.h
@@ -120,7 +120,7 @@ int amdgpu_ras_eeprom_read(struct amdgpu_ras_eeprom_control *control,
 int amdgpu_ras_eeprom_append(struct amdgpu_ras_eeprom_control *control,
 			     struct eeprom_table_record *records, const u32 num);
 
-inline uint32_t amdgpu_ras_eeprom_max_record_count(void);
+uint32_t amdgpu_ras_eeprom_max_record_count(void);
 
 void amdgpu_ras_debugfs_set_ret_size(struct amdgpu_ras_eeprom_control *control);
 

