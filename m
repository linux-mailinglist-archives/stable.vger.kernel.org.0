Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3030E1E2BE8
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391906AbgEZTKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391534AbgEZTKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 633B820873;
        Tue, 26 May 2020 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520204;
        bh=UM7I3L47W25YMxxLcbxVxwSxQCi28EC5cb/SVt9U61I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJsgAcyAcnaLvd7PB4SAmbhfh8/s1eH5n+QnVGsRVeg9zFGq39tMyMMEo3vrxhCYg
         qOhPgFUJfye+ozMErGpOj3lF4j9sszuXQXeeMEiceyqroay2xJNO8NvG+Y0C/8hw4J
         DQyKv3bsppkEmdxBNyf1Jf2wMMR9G+ui78rI3wu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Philipp Rudo <prudo@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 099/111] s390/kexec_file: fix initrd location for kdump kernel
Date:   Tue, 26 May 2020 20:53:57 +0200
Message-Id: <20200526183942.279942703@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

commit 70b690547d5ea1a3d135a4cc39cd1e08246d0c3a upstream.

initrd_start must not point at the location the initrd is loaded into
the crashkernel memory but at the location it will be after the
crashkernel memory is swapped with the memory at 0.

Fixes: ee337f5469fd ("s390/kexec_file: Add crash support to image loader")
Reported-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Tested-by: Lianbo Jiang <lijiang@redhat.com>
Link: https://lore.kernel.org/r/20200512193956.15ae3f23@laptop2-ibm.local
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/machine_kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -151,7 +151,7 @@ static int kexec_file_add_initrd(struct
 		buf.mem += crashk_res.start;
 	buf.memsz = buf.bufsz;
 
-	data->parm->initrd_start = buf.mem;
+	data->parm->initrd_start = data->memsz;
 	data->parm->initrd_size = buf.memsz;
 	data->memsz += buf.memsz;
 


