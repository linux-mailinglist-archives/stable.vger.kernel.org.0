Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758C379EDF
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 06:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhEKE5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 00:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhEKE5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 00:57:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508DC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 21:56:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id u25so4327923pgl.9
        for <stable@vger.kernel.org>; Mon, 10 May 2021 21:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aUGRz8/SddWKvaSwbd/gmBK3dNQK6bcFTy9KMxHsXLE=;
        b=oIu35dYa1zBfeRl9GRaXj07nlzTS/QaZ6ik9wg+u7tw/WEjLpv5lk/417kr7lzpcbw
         p+7LjeTajPKERta4fmZZ0lrWwQPfiBKvIvEXATAGg9A5h0R/4m8lunwxG6nD6bws9GaZ
         WOKfS9KQpGeNVXaZY4msVrTEB9Pez8eEzWR099ts7tw/nGZ4Vg/G+tie5zapNhVuBNad
         g6rO1NE55WwK492UUb3uLvkAHn+GuFVoBXh0WE0t1vkiTgu+BV6f0x4w8PWH/AhEY2IJ
         DSi0FLqiyLGlygmfca3espHHB+29z1kCEFrDv0yaPhOaYii0VAvz0nhrnFjiDMXsre/q
         TOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aUGRz8/SddWKvaSwbd/gmBK3dNQK6bcFTy9KMxHsXLE=;
        b=XeOiwpHPPlEFgZxYRXSBX59XyqTTkrz6Di7QN1lONJQ2LgDKzJd4+KB8lLpZn9ovPI
         TGlbXcml8RUd7MKi0k1oJV44ifvs27Usa8EgRQwkuRUtemFhaOZUcfZrcGrzL/cL/0gv
         BMnerBI8J6W+7c/3zXUoWYNhlzHSk+T4xx9JbjwPd7wJuAk2hgX9b2UP2Zx4RkFTOO3d
         LbepF9mz6GbYq6bBo69TtdEzXDzNk6Q11euYbDcFOGCtb76CBf9pIVvRYeenGEmMfBHs
         HDavLjx5n455Wl1xuqSuEeMpUMKJjW06bWmecLADyJTtwYGxPFLpfV094i8RYrGSo+nM
         pQTQ==
X-Gm-Message-State: AOAM533wFnw1dhQKIEuI1jLnxkUKxA/UVUs8tQAwmo2lJ5eg1hDkDoe9
        r1KhGxEcV4OhcPFEUsaGKTRWB/m7ZSE=
X-Google-Smtp-Source: ABdhPJxJe6E25A9kwbp3spEApj+7qFiUOvV4Hh3QkYnv86nGPSho9PY31uVarApzq+WC4pHAlhi8rg==
X-Received: by 2002:a63:cd11:: with SMTP id i17mr28474821pgg.74.1620709004047;
        Mon, 10 May 2021 21:56:44 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f12sm11880369pfv.155.2021.05.10.21.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:56:43 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] nvme-fc: clear q_live at beginning of association teardown
Date:   Mon, 10 May 2021 21:56:35 -0700
Message-Id: <20210511045635.12494-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The __nvmf_check_ready() routine used to bounce all filesystem io if
the controller state isn't LIVE. However, a later patch changed the
logic so that it rejection ends up being based on the Q live check.
The fc transport has a slightly different sequence from rdma and tcp
for shutting down queues/marking them non-live. FC marks its queue
non-live after aborting all ios and waiting for their termination,
leaving a rather large window for filesystem io to continue to hit the
transport. Unfortunately this resulted in filesystem io or applications
seeing I/O errors.

Change the fc transport to mark the queues non-live at the first
sign of teardown for the association (when i/o is initially terminated).

Fixes: 73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
stable trees for 5.8 and 5.9 will require a slightly modified patch
---
 drivers/nvme/host/fc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index d9ab9e7871d0..256e87721a01 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2461,6 +2461,18 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
 static void
 __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 {
+	int q;
+
+	/*
+	 * if aborting io, the queues are no longer good, mark them
+	 * all as not live.
+	 */
+	if (ctrl->ctrl.queue_count > 1) {
+		for (q = 1; q < ctrl->ctrl.queue_count; q++)
+			clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[q].flags);
+	}
+	clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[0].flags);
+
 	/*
 	 * If io queues are present, stop them and terminate all outstanding
 	 * ios on them. As FC allocates FC exchange for each io, the
-- 
2.26.2

