Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918626928C4
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjBJUwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjBJUwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:52:31 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179485FE5;
        Fri, 10 Feb 2023 12:52:30 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id pj3so6510051pjb.1;
        Fri, 10 Feb 2023 12:52:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/A/j3sjHfT49Ed2WzZTVw+auEmLb+Wp+YpWzo2DKZ4M=;
        b=PzjT7KwpKP89ad7bXellHPnDMP9hB0J2rACQ3IJFGpSnmrJ5MjFMAnms4edrKoU77U
         mCuiEb0H7lOC1L4JPLOWvxbgPv6px0kQhrhTtv+0LKC7w6iNGuEYlecA3m0mMEyKdNuI
         77FviT8tl86I5JhfnilgoFB3LtR9PZC5B1R7GRDjTlQTS9nD5o29Ui0sPmKLGFtqB53R
         5Nz9mlwtiOOJ03qmgFnR2LInJU51xiJ6es2VgKLjsKaqFs/IvCaOCF+ZTiXUmxUPWX+Z
         VWUK8cbyiugfaSPcP5rEXKYzZdoNmLO4nibukm2zXHQqmYmu0LQ0iafKa4jyp2jQNmBm
         /cPA==
X-Gm-Message-State: AO0yUKUynt7KrJnwLDQGZwT2+Uy0MBoOWEvEnvGdOf+BtNI2Fy7kSpKg
        SpfDo9+EUPjEdew30W+aYhw=
X-Google-Smtp-Source: AK7set/bUnEGLJr8I3LA464GRnFQyaf8QAnHqBPRXHovf1hjj3tPxON3Yud+X4Q8Axnvqmt1SIEu9g==
X-Received: by 2002:a17:902:d4cc:b0:198:9bf8:298e with SMTP id o12-20020a170902d4cc00b001989bf8298emr17947174plg.60.1676062349284;
        Fri, 10 Feb 2023 12:52:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id jm13-20020a17090304cd00b001948ff5cc32sm3745752plb.215.2023.02.10.12.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:52:28 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Yi Zhang <yi.zhang@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/2] scsi: core: Remove the /proc/scsi/${proc_name} directory earlier
Date:   Fri, 10 Feb 2023 12:52:00 -0800
Message-Id: <20230210205200.36973-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230210205200.36973-1-bvanassche@acm.org>
References: <20230210205200.36973-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove the /proc/scsi/${proc_name} directory earlier to fix a race
condition between unloading and reloading kernel modules. This patch
fixes a bug introduced in 2009 by patch "[SCSI] fix /proc memory leak
in the SCSI core".

This patch fixes the following kernel warning:

proc_dir_entry 'scsi/scsi_debug' already registered
WARNING: CPU: 19 PID: 27986 at fs/proc/generic.c:376 proc_register+0x27d/0x2e0
Call Trace:
 proc_mkdir+0xb5/0xe0
 scsi_proc_hostdir_add+0xb5/0x170
 scsi_host_alloc+0x683/0x6c0
 sdebug_driver_probe+0x6b/0x2d0 [scsi_debug]
 really_probe+0x159/0x540
 __driver_probe_device+0xdc/0x230
 driver_probe_device+0x4f/0x120
 __device_attach_driver+0xef/0x180
 bus_for_each_drv+0xe5/0x130
 __device_attach+0x127/0x290
 device_initial_probe+0x17/0x20
 bus_probe_device+0x110/0x130
 device_add+0x673/0xc80
 device_register+0x1e/0x30
 sdebug_add_host_helper+0x1a7/0x3b0 [scsi_debug]
 scsi_debug_init+0x64f/0x1000 [scsi_debug]
 do_one_initcall+0xd7/0x470
 do_init_module+0xe7/0x330
 load_module+0x122a/0x12c0
 __do_sys_finit_module+0x124/0x1a0
 __x64_sys_finit_module+0x46/0x50
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index b28375f9e019..f7f62e56afca 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -181,6 +181,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	scsi_proc_hostdir_rm(shost->hostt);
 
 	/*
 	 * New SCSI devices cannot be attached anymore because of the SCSI host
@@ -340,6 +341,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
