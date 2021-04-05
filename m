Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22046354017
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhDEJP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240396AbhDEJPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E44E61393;
        Mon,  5 Apr 2021 09:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614100;
        bh=chm6YtL0NmH9DtgHajEjtlF/dcJlt3FvkVNXFak/v0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtD5DJZ47C0vM+7f2Ga5ykI3U/qsFTzKlC1VEqo6UV4bkt7IzDSCuBcww04A4+nOu
         IWrDFqyxvgwNf8L/y6qIp0CrNGCNPqL6MXCuBYoYzgDOEpC6zrPPLSGFDA9jYyl5o4
         pW++fAC9JqeIPTfzhXrA9ff9U2iVb1FhWZdqOx20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 084/152] s390/vdso: copy tod_steering_delta value to vdso_data page
Date:   Mon,  5 Apr 2021 10:53:53 +0200
Message-Id: <20210405085036.978504904@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 72bbc226ed2ef0a46c165a482861fff00dd6d4e1 upstream.

When converting the vdso assembler code to C it was forgotten to
actually copy the tod_steering_delta value to vdso_data page.

Which in turn means that tod clock steering will not work correctly.

Fix this by simply copying the value whenever it is updated.

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -398,6 +398,7 @@ static void clock_sync_global(unsigned l
 		      tod_steering_delta);
 	tod_steering_end = now + (abs(tod_steering_delta) << 15);
 	vdso_data->arch_data.tod_steering_end = tod_steering_end;
+	vdso_data->arch_data.tod_steering_delta = tod_steering_delta;
 
 	/* Update LPAR offset. */
 	if (ptff_query(PTFF_QTO) && ptff(&qto, sizeof(qto), PTFF_QTO) == 0)


