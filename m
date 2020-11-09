Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEB2ABD15
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgKINmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbgKINAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:00:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7B5221F9;
        Mon,  9 Nov 2020 13:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926832;
        bh=3+iVDUeYUQtCG1b7ztjZJ6YpyRlZ9aI6xSrMEGpP3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSkmlikiWs58l0640PBypqud7tvfuwyLNYfXFSJ8bwS0UcE5/BfnpCRtmqpgieMb2
         2tU12Z6zNnD0fZ/m+a3ZQAxKfEQ9pqBsqffJ/JRun8VAjMfPDVeLKHjtBkUrIH5a5r
         GIpkR94QJlmHvqpRsk+FdiA04gdomvn/Z17TrCkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mukesh Ojha <mukesh02@linux.vnet.ibm.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 4.9 003/117] powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler
Date:   Mon,  9 Nov 2020 13:53:49 +0100
Message-Id: <20201109125025.792602108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mukesh Ojha <mukesh02@linux.vnet.ibm.com>

commit b29336c0e1785a28bc40a9fd47c2321671e9792e upstream.

Fixes: 8034f715f ("powernv/opal-dump: Convert to irq domain")

Converts all the return explicit number to a more proper IRQ_HANDLED,
which looks proper incase of interrupt handler returning case.

Here, It also removes error message like "nobody cared" which was
getting unveiled while returning -1 or 0 from handler.

Signed-off-by: Mukesh Ojha <mukesh02@linux.vnet.ibm.com>
Reviewed-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-dump.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/powerpc/platforms/powernv/opal-dump.c
+++ b/arch/powerpc/platforms/powernv/opal-dump.c
@@ -385,13 +385,12 @@ static irqreturn_t process_dump(int irq,
 {
 	int rc;
 	uint32_t dump_id, dump_size, dump_type;
-	struct dump_obj *dump;
 	char name[22];
 	struct kobject *kobj;
 
 	rc = dump_read_info(&dump_id, &dump_size, &dump_type);
 	if (rc != OPAL_SUCCESS)
-		return rc;
+		return IRQ_HANDLED;
 
 	sprintf(name, "0x%x-0x%x", dump_type, dump_id);
 
@@ -403,12 +402,10 @@ static irqreturn_t process_dump(int irq,
 	if (kobj) {
 		/* Drop reference added by kset_find_obj() */
 		kobject_put(kobj);
-		return 0;
+		return IRQ_HANDLED;
 	}
 
-	dump = create_dump_obj(dump_id, dump_size, dump_type);
-	if (!dump)
-		return -1;
+	create_dump_obj(dump_id, dump_size, dump_type);
 
 	return IRQ_HANDLED;
 }


