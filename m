Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0939CAE1
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 22:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFEUXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 16:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhFEUXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 16:23:12 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E383C061766;
        Sat,  5 Jun 2021 13:21:08 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f11so19308256lfq.4;
        Sat, 05 Jun 2021 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ogeBL4TcRDY07px4nouuwmteF277fCXlnUA+B+W6KM=;
        b=mqqKwwLvMDY3JlUWWWYLyoi/pDeqzc6aUpBSLsDNUYKPFUW/jsQUOWtQ1jnHCg5EgG
         delRQ/eQ+VcplHkZhp8MXSXV5dpoKSK8p/iDfUdE5+SZgIAuprM6SJOmSKYwDxm4v0kH
         ckSi4B8Zh16QiPdwmhLEW4VkWgSmxs15GjBNOBPVXohx397jOgoepgC41NLxwI/+AOge
         jYuUEJ0nMd8+dBHADULuJwg8MNAqsidltpNHfA+UT8qzEUdvsGW0FGQs1KUm6YshjXKE
         a5igEKJasg4hKHoao1LYFltlKKJ7CV3Wv+tg/9+mV0WV13Dog/Y03imQ4/EP5cSMxcsP
         nsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ogeBL4TcRDY07px4nouuwmteF277fCXlnUA+B+W6KM=;
        b=MyKIKk8EUOFhq3YSInc7Kd4l99mYOiYYORH02UK79p3yvvqUzDXrbNGoajRP9DK+W0
         StiR4NRXetjJmoMDyyQ0C0zUh89MsluFRn2Nl0XfxTEFSwAYSJGjOaGzDZsaPUjex3Hj
         P9gouvhCU4VQyPbELVJ/yJksvArwvAMEITjwLPSXTRahcRaa3MMVHNFFTyk/JecyxlJu
         KS4wNF4/I7x8ou+k42bBb40q+KBqYZ4T3DPNp1TTE+CwBuhLwOrU9BdpCnfKyDRqyKBB
         cvnz+/qT3wX9wAL87rdK7qfe8vvPLKKU5riqQSj9olA4j7GsNZxEeneHw6AjOduuo1yf
         gN3w==
X-Gm-Message-State: AOAM531hdGCRH35O/HJDf7Oc70c1g95aXW0tVClI2rIFnjmFP5+137aV
        9Cjg5RPM6nUbiit8wAm32ZM=
X-Google-Smtp-Source: ABdhPJyT/r2kiS8+pHX0yX1Hgi8Lw8GXSW7vBmHaEZESE8HfV+DkRY5gU8Te6n8ghcaK/KJT8CBohA==
X-Received: by 2002:ac2:57c1:: with SMTP id k1mr1213103lfo.231.1622924466507;
        Sat, 05 Jun 2021 13:21:06 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id o14sm954399lfi.193.2021.06.05.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 13:21:05 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        shayd@nvidia.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] infiniband: core: fix memory leak
Date:   Sat,  5 Jun 2021 23:20:51 +0300
Message-Id: <20210605202051.14783-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My local syzbot instance hit memory leak in
copy_process(). The problem was in unputted task
struct in _destroy_id().

Simple reproducer:

int main(void)
{
        struct rdma_ucm_cmd_hdr *hdr;
        struct rdma_ucm_create_id *cmd_id;
        char cmd[sizeof(*hdr) + sizeof(*cmd_id)] = {0};
        int fd;

        hdr = (struct rdma_ucm_cmd_hdr *)cmd;
        cmd_id = (struct rdma_ucm_create_id *) (cmd + sizeof(*hdr));

        hdr->cmd = 0;
        hdr->in = 0x18;
        hdr->out = 0xfa00;

        cmd_id->uid = 0x3;
        cmd_id->response = 0x0;
        cmd_id->ps = 0x106;

        fd = open("/dev/infiniband/rdma_cm", O_WRONLY);
        write(fd, cmd, sizeof(cmd));
}

Ftrace log:

ucma_open();
ucma_write() {
  ucma_create_id() {
    ucma_alloc_ctx();
    rdma_create_user_id() {
      rdma_restrack_new();
      rdma_restrack_set_name() {
        rdma_restrack_attach_task.part.0(); <--- task_struct getted
      }
    }
    ucma_destroy_private_ctx() {
      ucma_put_ctx();
      rdma_destroy_id() {
        _destroy_id()			    <--- id_priv freed
      }
    }
  }
}
ucma_close();

From previous log it's easy to undertand that
_destroy_id() is the last place, where task_struct
can be putted, because at the end of this function
id_priv is freed.

With this patch applied, above reproducer doesn't hit memory
leak anymore.

Fixes: e51060f08a61 ("IB: IP address based RDMA connection manager")
Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ab148a696c0c..2760352261b3 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1874,6 +1874,7 @@ static void _destroy_id(struct rdma_id_private *id_priv,
 
 	kfree(id_priv->id.route.path_rec);
 
+	rdma_restrack_put(&id_priv->res);
 	put_net(id_priv->id.route.addr.dev_addr.net);
 	kfree(id_priv);
 }
-- 
2.31.1

