Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C781A0BD0
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgDGKXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgDGKXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2C62082F;
        Tue,  7 Apr 2020 10:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255026;
        bh=nekBzOBwg7MSUfjgB1WlnAg8CmwfUXUhpErEo3+ryck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNVFq+XqU5cx6eFcob+kdPCLbvsXjkIZIJLhvE1WsGVRKesou87Y3dJPkrlVo1inW
         MdKz7qi69noGvjSTBWQtZGs9s9gkEK7WmKT3W+VDWu4WHJzApoLTQJSWudsN4vWWni
         JnZhR3VzC4EY80/AyebIMbosG6szOf2QgG7+8I5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 5.4 36/36] padata: always acquire cpu_hotplug_lock before pinst->lock
Date:   Tue,  7 Apr 2020 12:22:09 +0200
Message-Id: <20200407101458.815698923@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 38228e8848cd7dd86ccb90406af32de0cad24be3 upstream.

lockdep complains when padata's paths to update cpumasks via CPU hotplug
and sysfs are both taken:

  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

  ======================================================
  WARNING: possible circular locking dependency detected
  5.4.0-rc8-padata-cpuhp-v3+ #1 Not tainted
  ------------------------------------------------------
  bash/205 is trying to acquire lock:
  ffffffff8286bcd0 (cpu_hotplug_lock.rw_sem){++++}, at: padata_set_cpumask+0x2b/0x120

  but task is already holding lock:
  ffff8880001abfa0 (&pinst->lock){+.+.}, at: padata_set_cpumask+0x26/0x120

  which lock already depends on the new lock.

padata doesn't take cpu_hotplug_lock and pinst->lock in a consistent
order.  Which should be first?  CPU hotplug calls into padata with
cpu_hotplug_lock already held, so it should have priority.

Fixes: 6751fb3c0e0c ("padata: Use get_online_cpus/put_online_cpus")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -643,8 +643,8 @@ int padata_set_cpumask(struct padata_ins
 	struct cpumask *serial_mask, *parallel_mask;
 	int err = -EINVAL;
 
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -662,8 +662,8 @@ int padata_set_cpumask(struct padata_ins
 	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }


