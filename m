Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A923E6907
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfJ0VLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbfJ0VLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DFCE205C9;
        Sun, 27 Oct 2019 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210711;
        bh=ssO/fgfxNpvpT7q/HqGLGpAcTTDrtqgKuanlAZwDpQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzdLe2tVhiYtHWixGUmNcH0ZjtGjnL/xJt0SaHhdDHePhhSLw8Wq1nhNEbHmKzAl5
         DI6KC0mg++L8i0BiDjmHT+XJpKQAjYkLsNmuYYXx2/5tx6YozSIQtqcU3ZME1dJY/a
         5LsWqxwgcCnPkC2Wrxc0Bk8m0/xHepOZn8Lnvgpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 111/119] memstick: jmb38x_ms: Fix an error handling path in jmb38x_ms_probe()
Date:   Sun, 27 Oct 2019 22:01:28 +0100
Message-Id: <20191027203349.582152782@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 28c9fac09ab0147158db0baeec630407a5e9b892 upstream.

If 'jmb38x_ms_count_slots()' returns 0, we must undo the previous
'pci_request_regions()' call.

Goto 'err_out_int' to fix it.

Fixes: 60fdd931d577 ("memstick: add support for JMicron jmb38x MemoryStick host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memstick/host/jmb38x_ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -947,7 +947,7 @@ static int jmb38x_ms_probe(struct pci_de
 	if (!cnt) {
 		rc = -ENODEV;
 		pci_dev_busy = 1;
-		goto err_out;
+		goto err_out_int;
 	}
 
 	jm = kzalloc(sizeof(struct jmb38x_ms)


