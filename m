Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16641D22F9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfJJIi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfJJIi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17300218AC;
        Thu, 10 Oct 2019 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696707;
        bh=CrByy6AiiNIBc0tpoJVDjGCyRJO9uiveU3kjBybQo3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyEIlrBoGeX4CZFFqjbct+Aa8I1S6C/aDpkLPOs/oOz9aDsOWvwDTmYvs01Q8CCTp
         ZTbO9fXciPXue/Rb1KJ7qX/qO36tCgs1OFkgrdYb24/UdjPhPVL+sRFBHxjajaYGO/
         /r3SsQ2jArtpzsO7OM2V5xDBDYidbPHPYFlvrcC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 023/148] powerpc/mce: Schedule work from irq_work
Date:   Thu, 10 Oct 2019 10:34:44 +0200
Message-Id: <20191010083612.521688817@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Santosh Sivaraj <santosh@fossix.org>

commit b5bda6263cad9a927e1a4edb7493d542da0c1410 upstream.

schedule_work() cannot be called from MCE exception context as MCE can
interrupt even in interrupt disabled context.

Fixes: 733e4a4c4467 ("powerpc/mce: hookup memory_failure for UE errors")
Cc: stable@vger.kernel.org # v4.15+
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190820081352.8641-2-santosh@fossix.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/mce.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -33,6 +33,7 @@ static DEFINE_PER_CPU(struct machine_che
 					mce_ue_event_queue);
 
 static void machine_check_process_queued_event(struct irq_work *work);
+static void machine_check_ue_irq_work(struct irq_work *work);
 void machine_check_ue_event(struct machine_check_event *evt);
 static void machine_process_ue_event(struct work_struct *work);
 
@@ -40,6 +41,10 @@ static struct irq_work mce_event_process
         .func = machine_check_process_queued_event,
 };
 
+static struct irq_work mce_ue_event_irq_work = {
+	.func = machine_check_ue_irq_work,
+};
+
 DECLARE_WORK(mce_ue_event_work, machine_process_ue_event);
 
 static void mce_set_error_info(struct machine_check_event *mce,
@@ -199,6 +204,10 @@ void release_mce_event(void)
 	get_mce_event(NULL, true);
 }
 
+static void machine_check_ue_irq_work(struct irq_work *work)
+{
+	schedule_work(&mce_ue_event_work);
+}
 
 /*
  * Queue up the MCE event which then can be handled later.
@@ -216,7 +225,7 @@ void machine_check_ue_event(struct machi
 	memcpy(this_cpu_ptr(&mce_ue_event_queue[index]), evt, sizeof(*evt));
 
 	/* Queue work to process this event later. */
-	schedule_work(&mce_ue_event_work);
+	irq_work_queue(&mce_ue_event_irq_work);
 }
 
 /*


