Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247B04514C1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349473AbhKOUMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345004AbhKOTZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D7FA63712;
        Mon, 15 Nov 2021 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003309;
        bh=VOpEUYT7XfCuSTWtvSm253tVXWEbJz5MI/Bx2JMBAOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMLQmHm7k8OeVX885MQEtXX3NzlBOKRLT0uPUgOKyakJYb0A4LfJetmUzeqacOb3q
         vmWacIZ9LyxRvYvYMVbJC0Zp0aKbuKEiLdu4TcrVScv4CMtfJ3F90vdODLB2BFIYsn
         dA7Gn6Vtbaz11X54dzNgsZCFJy5CwP6fqfiWJBZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 888/917] s390/cio: check the subchannel validity for dev_busid
Date:   Mon, 15 Nov 2021 18:06:23 +0100
Message-Id: <20211115165459.168052346@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit a4751f157c194431fae9e9c493f456df8272b871 upstream.

Check the validity of subchanel before reading other fields in
the schib.

Fixes: d3683c055212 ("s390/cio: add dev_busid sysfs entry for each subchannel")
CC: <stable@vger.kernel.org>
Reported-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20211105154451.847288-1-vneethv@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/css.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -437,8 +437,8 @@ static ssize_t dev_busid_show(struct dev
 	struct subchannel *sch = to_subchannel(dev);
 	struct pmcw *pmcw = &sch->schib.pmcw;
 
-	if ((pmcw->st == SUBCHANNEL_TYPE_IO ||
-	     pmcw->st == SUBCHANNEL_TYPE_MSG) && pmcw->dnv)
+	if ((pmcw->st == SUBCHANNEL_TYPE_IO && pmcw->dnv) ||
+	    (pmcw->st == SUBCHANNEL_TYPE_MSG && pmcw->w))
 		return sysfs_emit(buf, "0.%x.%04x\n", sch->schid.ssid,
 				  pmcw->dev);
 	else


