Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B6334D67E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2SBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:01:13 -0400
Received: from mengyan1223.wang ([89.208.246.23]:52630 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhC2SAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:00:53 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 14:00:53 EDT
Received: from xry111-X57S1.. (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 27C1965B2D;
        Mon, 29 Mar 2021 13:54:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617040502;
        bh=Zbib90WcD3Bj0OIpXKzlZugk4FNdHitNgQA0jv+MLiU=;
        h=From:To:Cc:Subject:Date:From;
        b=RU+YMOzQvm+gW5FvX3GXZLNVPhBUjDloPV82MoeNw7oievKXs/gIQiWpL5SBftjTW
         d80gOOr+DddPwloNLOzXp0GCnIqS4W/QbxFmYxRJ4hxQM4kiLJuUw2EePkXE0aVs/Y
         uBoJIXzvqR/4zCsmk6uTiAuRooaRityvTiWnlpgtq/jHPAHy1TjtfggLtue9OQWuuN
         4IWWrENjuf1vXeIibEui8gWSZqNaGpIDucg85Hg+Ngyb2oNEdeff6GEQAt5NIz0QZC
         1i2W4g7bEOK+b6d3v+3RGHoKP6ez8+NS8SJVCp+1AiooXOScYkg3zc2OQk3yA+piYk
         ReaBEHE9AvPfQ==
From:   =?UTF-8?q?X=E2=84=B9=20Ruoyao?= <xry111@mengyan1223.wang>
To:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?X=E2=84=B9=20Ruoyao?= <xry111@mengyan1223.wang>,
        =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
        stable@vger.kernel.org
Subject: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
Date:   Tue, 30 Mar 2021 01:53:48 +0800
Message-Id: <20210329175348.26859-1-xry111@mengyan1223.wang>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the initial value of `num_entires` (calculated at line 1654) is not
an integral multiple of `AMDGPU_GPU_PAGES_IN_CPU_PAGE`, in line 1681 a
value greater than the initial value will be assigned to it.  That causes
`start > last + 1` after line 1708.  Then in the next iteration an
underflow happens at line 1654.  It causes message

    *ERROR* Couldn't update BO_VA (-12)

printed in kernel log, and GPU hanging.

Fortify the criteria of the loop to fix this issue.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
Reported-by: Dan Horák <dan@danny.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index ad91c0c3c423..cee0cc9c8085 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct amdgpu_device *adev,
 		}
 		start = tmp;
 
-	} while (unlikely(start != last + 1));
+	} while (unlikely(start < last + 1));
 
 	r = vm->update_funcs->commit(&params, fence);
 

base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3
-- 
2.31.1

