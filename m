Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134928255D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHETMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:12:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44613 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728870AbfHETMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:12:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so40088014pfe.11
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=vtitsEfCLIcgWDSU/Pqr9Ff/BPWz7Dz8Ou3pTEj7AjI=;
        b=Sb69XAQ3sWqeF/XYUrorYl/eDRvd8KIxIwjvYnKTz8DBBKRsub8+sOUHCy3/El9F3w
         KmmKlCToeXJum7XzBngrYNKOm7n8vSCrwq3gFugYQ0mM6WsQ7o0IPZqBBElZdIleJqSK
         auktsYLyP2jfkoLYtJpLIbXhk6V6+TtnJGQozYl/vT/FtClkLNVj2LQZ5LlFY1E39On3
         RlI1KOzkbmYcMbjUia/6eC0h80Lzh9Vv2+nL1UYcSEXS2f8/dm6h6wRIsdBLYYt6gZYr
         6kbhj64Wp/reObecov4drAqs0cFmWPgxZfF6hk06xwmAgTx7ulW3DlQ5cPeDPH/hensL
         Gjmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=vtitsEfCLIcgWDSU/Pqr9Ff/BPWz7Dz8Ou3pTEj7AjI=;
        b=tychVME/MjbsYJPOSUAEXPs51dq/YS3WjcOAcH2hVQtZDQLMDEBo+oOQzZntB70Jli
         A93qVz+6RtiYzE3uWCmcyUWRFMXHZqQHK5lnU66Hbu7aL8USBDJXqCRW+quk/2sQyh7f
         D9elTmMZncZ0Wz8qwUbjj6FBkRRWZS5htUrtCIC1Is7D/xOBLP9xcSh1+zoNhoCtC0Tp
         nvQ0v15x9jqGvcV49ZWIJdhyjrxy3siIzhmONVtXyuxvOOOvGapIMnYUhjpPjr8h7Dw4
         6S5zToLfKgtPDoVxwAf0HLAqp3GKndzqWvnFf0MYdfu7SsBF3uZrOsrKOnZxzvWk1S1E
         3m/Q==
X-Gm-Message-State: APjAAAUKWs/nAR3uE9Rt1BwyMm4zcvSzkrbMRTRR2SCOX12bmwMcjX84
        L69/K/+BGOBm9gMPB47kXGk=
X-Google-Smtp-Source: APXvYqwThzcuvMVSD51IeJhYxMyoyGorVqVyi2lsDq19xyzGjSvwckkS6ORzKZ67P+bzLrmzYtsdvQ==
X-Received: by 2002:a17:90a:30aa:: with SMTP id h39mr19813788pjb.32.1565032368433;
        Mon, 05 Aug 2019 12:12:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 131sm103433958pfx.57.2019.08.05.12.12.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:12:47 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, xiao jin <jin.xiao@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.4.y, v4.9.y] block: blk_init_allocated_queue() set q->fq as NULL in the fail case
Date:   Mon,  5 Aug 2019 12:12:45 -0700
Message-Id: <1565032365-7089-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>

commit 54648cf1ec2d7f4b6a71767799c45676a138ca24 upstream

We find the memory use-after-free issue in __blk_drain_queue()
on the kernel 4.14. After read the latest kernel 4.18-rc6 we
think it has the same problem.

Memory is allocated for q->fq in the blk_init_allocated_queue().
If the elevator init function called with error return, it will
run into the fail case to free the q->fq.

Then the __blk_drain_queue() uses the same memory after the free
of the q->fq, it will lead to the unpredictable event.

The patch is to set q->fq as NULL in the fail case of
blk_init_allocated_queue().

Fixes: commit 7c94e1c157a2 ("block: introduce blk_flush_queue to drive flush machinery")
Cc: <stable@vger.kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[groeck: backport to v4.4.y/v4.9.y (context change)]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This patch was not applied to v4.4.y and v4.9.y due to a context conflict.
See https://lore.kernel.org/stable/1536310209129100@kroah.com/ and
https://lore.kernel.org/stable/153631018011582@kroah.com/ for details.
It was applied to v4.14.y and to v4.18.y.

Please consider applying this backport. It is relevant because it fixes
CVE-2018-20856.

Thanks,
Guenter

 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 50d77c90070d..7662f97dded6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -870,6 +870,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 
 fail:
 	blk_free_flush_queue(q->fq);
+	q->fq = NULL;
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
-- 
2.7.4

