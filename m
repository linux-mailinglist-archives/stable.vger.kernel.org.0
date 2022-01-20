Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693249554F
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 21:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377578AbiATURq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 15:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiATURq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 15:17:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197C6C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:17:46 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c9so6090091plg.11
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlPsJQF6w95TYMV7kIVyZ9NRoUvlo4VZyhhGBux+ZJk=;
        b=d6xUHpdZIieaGU97YO7Tv9OrD+DIdYl2fFz7HxJDv/htSNa6ZIQxBqMmKbHk7Td2oi
         36tofJyMY7/HvCPz0eLGrgglakAdNe5sfHwKygLYnr6ixRvNRL+fPxU4piuwGnVndzFz
         UHrVizGN7ByJQEqcRrH25N0wcvs0+y95Cr5Iq9rivhN6jDVaHOzolwWveP8hVLD9iZeS
         UijNvpptTMxhXg+nGT7BONBVvoZ3y/DQDMvG1fUv0fiG5E2345KnbjZx1WyaEcwB3Jjy
         vvObs3MWAcoZJnhQtKUxt4+9OnmYBMjEUPMQ4hKAr6qunlo5veDTKpe4euSZ0wREBXHR
         13Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlPsJQF6w95TYMV7kIVyZ9NRoUvlo4VZyhhGBux+ZJk=;
        b=XRPZjLdjdXA5cOWLdm4XsI95s9k+YYhyNonUfCvdVJ+rC/c5hYjBld9Wev0j3/ev7v
         NVf0eaXpxz+fXpPloChmWaYXrG2e5l75vF/gT4zxGVMi5GdiaEH93z6klCERqMakBbue
         sWZ1bPBCAhaHbMpsJ14zHsE2NgsZDH71rusWL1jf6Pa7UbUv4lI/auXD0PTgIsDvD5HR
         +4SHrYlAot+nR4KriakgzqC/B/y4E55pBguA/TU0yrLM9Q/CbY0NFy3IrTaIIw40jIHO
         gDGfTSlZZ3a1BHUUY4XSvYgjDbUKIgrlC/GPG90TszXdsaENL7APWGZgqfkz2jGO9PIy
         43AA==
X-Gm-Message-State: AOAM530s+Mn6c6xLfPrK9SeAhV4eqyT/VyD4CP9Fgvzm5YJNk5dT9NxI
        zFrRQSpDJQ9FF2GWr4qkYJ+T//OSm6U=
X-Google-Smtp-Source: ABdhPJxvuKyuc/8G6MX98+TcxExF9Wu1y/YhijW1WT4MWngHbqCZYHXZfUoDoSaYT5BWD4gxxwfsHw==
X-Received: by 2002:a17:902:70cb:b0:14a:b8e7:4437 with SMTP id l11-20020a17090270cb00b0014ab8e74437mr656271plt.41.1642709865384;
        Thu, 20 Jan 2022 12:17:45 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p10sm505859pgr.5.2022.01.20.12.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 12:17:45 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Uday Shankar <ushankar@purestorage.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH] nvme-fabrics: Fix state check in nvmf_ctlr_matches_baseopts()
Date:   Thu, 20 Jan 2022 12:17:37 -0800
Message-Id: <20220120201737.65390-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uday Shankar <ushankar@purestorage.com>

Controller deletion/reset, immediately followed by or concurrent with
a reconnect, is hard failing the connect attempt resulting in a
complete loss of connectivity to the controller.

In the connect request, fabrics looks for an existing controller with
the same address components and aborts the connect if a controller
already exists and the duplicate connect option isn't set. The match
routine filters out controllers that are dead or dying, so they don't
interfere with the new connect request.

When NVME_CTRL_DELETING_NOIO was added, it missed updating the state
filters in the nvmf_ctlr_matches_baseopts() routine. Thus, when in this
new state, it's seen as a live controller and fails the connect request.

Correct by adding the DELETING_NIO state to the match checks.

Fixes: ecca390e8056 ("nvme: fix deadlock in disconnect during scan_work and/or ana_work")
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
CC: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/fabrics.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index c3203ff1c654..1e3a09cad961 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -170,6 +170,7 @@ nvmf_ctlr_matches_baseopts(struct nvme_ctrl *ctrl,
 			struct nvmf_ctrl_options *opts)
 {
 	if (ctrl->state == NVME_CTRL_DELETING ||
+	    ctrl->state == NVME_CTRL_DELETING_NOIO ||
 	    ctrl->state == NVME_CTRL_DEAD ||
 	    strcmp(opts->subsysnqn, ctrl->opts->subsysnqn) ||
 	    strcmp(opts->host->nqn, ctrl->opts->host->nqn) ||
-- 
2.26.2

