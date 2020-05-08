Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE851CAB62
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgEHMnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbgEHMnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2BA24971;
        Fri,  8 May 2020 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941788;
        bh=zqQDo8kzp6NEGA2JyNikZe5le3hBvC/lDrV5X0I49l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhZSqZzzSyWC4anx/7fADtt8O51rbpG3qBDBY9r2q1NE2/PhlT3IHinyjWXvdcHWa
         iwqwXRbnd9GqxA0++C+JPjwSmg/X9Z+MIkJjsRzeENcW98DFHOt1uzUsAlILuTuV7N
         FuqZeQhQ8+khzM+T1trP3kd1RunBMtVLZmssDMq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 172/312] [media] cx23885: uninitialized variable in cx23885_av_work_handler()
Date:   Fri,  8 May 2020 14:32:43 +0200
Message-Id: <20200508123136.598357947@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 60587bd0680507f48ae3a7360983228fd207de8a upstream.

The "handled" variable could be uninitialized if the
interrupt_service_routine() call back hasn't been implimented or if it
has been implemented but doesn't initialize "handled" to zero at the
start.  For example, adv76xx_isr() only sets "handled" to true.

Fixes: 44b153ca639f ('[media] m5mols: Add ISO sensitivity controls')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx23885/cx23885-av.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/cx23885/cx23885-av.c
+++ b/drivers/media/pci/cx23885/cx23885-av.c
@@ -24,7 +24,7 @@ void cx23885_av_work_handler(struct work
 {
 	struct cx23885_dev *dev =
 			   container_of(work, struct cx23885_dev, cx25840_work);
-	bool handled;
+	bool handled = false;
 
 	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
 			 PCI_MSK_AV_CORE, &handled);


