Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9469450C8A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbhKORjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238273AbhKORfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D9B60E0C;
        Mon, 15 Nov 2021 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997032;
        bh=fF0/bSdgt83uDRIEUWePQzMO9jej4LJFY6K8cRSonv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9V5Itpcv5keJmP9SuxK1szCWx75jzF89089VpcWjfxZ6ESwDK1y4rlPN2ZcXdcAG
         NWCADWwKRXu1zvVpZJAOiEAoCbt8Xha8dabko6QY/gil/LJMlk4TcfsLhlFsvdfoL7
         S7yirKWZmTPuOVThPKMrjD/xefXoQnZDATT8Jk3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 350/355] s390/cio: check the subchannel validity for dev_busid
Date:   Mon, 15 Nov 2021 18:04:34 +0100
Message-Id: <20211115165325.073002938@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
@@ -433,8 +433,8 @@ static ssize_t dev_busid_show(struct dev
 	struct subchannel *sch = to_subchannel(dev);
 	struct pmcw *pmcw = &sch->schib.pmcw;
 
-	if ((pmcw->st == SUBCHANNEL_TYPE_IO ||
-	     pmcw->st == SUBCHANNEL_TYPE_MSG) && pmcw->dnv)
+	if ((pmcw->st == SUBCHANNEL_TYPE_IO && pmcw->dnv) ||
+	    (pmcw->st == SUBCHANNEL_TYPE_MSG && pmcw->w))
 		return sysfs_emit(buf, "0.%x.%04x\n", sch->schid.ssid,
 				  pmcw->dev);
 	else


