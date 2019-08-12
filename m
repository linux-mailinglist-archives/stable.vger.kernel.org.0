Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B53899C5
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfHLJW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 05:22:57 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38016 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfHLJW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 05:22:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so9023882plt.5
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xo5GxV2VUz5oUEAom/90QFb/1qeb/Ep256qNvcX0mNY=;
        b=qYKPu7dQnJ+efxNuKAgOhhGHbAtOXZiq6e8QCQ68gncmUnNmf7V9YNSsDwdaNeQBPE
         xJmNTmwZKEylqy/Ylcwjisr3ExW+75yriMU6j0SKUI30CDpDMfXvTU4qt7TR3cu//PiM
         K6CZg2/N7KBO7pr4kvvBdYbVgRldlXRmV3gu6BcETBXEu7crWdPdZoYoXEnLP/4w19TM
         oCXBVrbx+xktP79mC8nCIBoOwhvxzSAvNmcOjQP0BJm0ZwoPT/qCNb2dtN5+BGfGvyzi
         vgEzaXHDCNKV1eajtKIwM1yUdNMUemKkeGsqIj9djgeTOWYPPi5bc0e0fb10VWJXq6Fs
         1jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xo5GxV2VUz5oUEAom/90QFb/1qeb/Ep256qNvcX0mNY=;
        b=anRHDJBKXlPjr2gDDZ6aZ4L+y+8FWRZsDXAkwOHxivSObpgy77o63GGH4HKoFqj2cn
         J3knqaTla36YeehP35chsVXunauN+9XKnxJb+SatckXWu9iPp/ktfXcjspiKUFVg2sFl
         XrA1tjvHRpd8Roay0tT3+bA+gVXgqJMv6fLXqWsdskZ2uev/rVBXW2PwMeZbsdNaf+Qu
         Qi80ilfPHfV7LG7lAfN2BprQ6rTEuwYigrM9e0LjIWVnZIA7X11/E4J74ZfQymWA61La
         1gEiaBXmklPDWtKRdO5kV1crxbaMS4sbl3SS4qJT23YZUbbjIKk4G90SC7PSoqshcxOc
         fAeQ==
X-Gm-Message-State: APjAAAV6vY3NYBSA3EIPgE2IzfgUwTJejFDNq5xRr13wzYKfpPUWupCg
        GnzS0tRe+RgHowub4XrciTYbtw==
X-Google-Smtp-Source: APXvYqwtw33Uv4tZNCnDJo6DvoapC5CmXz0Ep2dPuTnN0OYxub03wKeh9P4Gz/QX5Ibf+5KkSX/mqA==
X-Received: by 2002:a17:902:f81:: with SMTP id 1mr31777188plz.191.1565601775904;
        Mon, 12 Aug 2019 02:22:55 -0700 (PDT)
Received: from santosiv.in.ibm.com ([129.41.84.75])
        by smtp.gmail.com with ESMTPSA id y188sm10543517pfb.115.2019.08.12.02.22.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 02:22:55 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v9 1/7] powerpc/mce: Schedule work from irq_work
Date:   Mon, 12 Aug 2019 14:52:30 +0530
Message-Id: <20190812092236.16648-2-santosh@fossix.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812092236.16648-1-santosh@fossix.org>
References: <20190812092236.16648-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

schedule_work() cannot be called from MCE exception context as MCE can
interrupt even in interrupt disabled context.

fixes: 733e4a4c ("powerpc/mce: hookup memory_failure for UE errors")
Suggested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Cc: stable@vger.kernel.org # v4.15+
---
 arch/powerpc/kernel/mce.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index b18df633eae9..cff31d4a501f 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -33,6 +33,7 @@ static DEFINE_PER_CPU(struct machine_check_event[MAX_MC_EVT],
 					mce_ue_event_queue);
 
 static void machine_check_process_queued_event(struct irq_work *work);
+static void machine_check_ue_irq_work(struct irq_work *work);
 void machine_check_ue_event(struct machine_check_event *evt);
 static void machine_process_ue_event(struct work_struct *work);
 
@@ -40,6 +41,10 @@ static struct irq_work mce_event_process_work = {
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
@@ -216,7 +225,7 @@ void machine_check_ue_event(struct machine_check_event *evt)
 	memcpy(this_cpu_ptr(&mce_ue_event_queue[index]), evt, sizeof(*evt));
 
 	/* Queue work to process this event later. */
-	schedule_work(&mce_ue_event_work);
+	irq_work_queue(&mce_ue_event_irq_work);
 }
 
 /*
-- 
2.21.0

