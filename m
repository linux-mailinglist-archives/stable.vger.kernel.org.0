Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548583786C4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhEJLKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhEJLEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:04:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36BC061972;
        Mon, 10 May 2021 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644090;
        bh=B+d/HMwJwK+LTT8jqMhAP0iUKjA1x0huLN614HZVKkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnfdGg1T2rZ5sEnICR1pj1RdVtFT/KocZO0zXZJhVTKOBqRoW8w8Afkmkk9Y0Cg4L
         Rp/Z3pCnEdywXyGdWa3hSAFhCi7HhZQZPiPRdmt2ZzD6+ytz/befO7XhuHj63TpWtg
         zDMcK7+kyXx+YMHMsyCH2GyNgOw5Nd04z3D30tvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.11 282/342] tpm: vtpm_proxy: Avoid reading host log when using a virtual device
Date:   Mon, 10 May 2021 12:21:12 +0200
Message-Id: <20210510102019.422906795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit 9716ac65efc8f780549b03bddf41e60c445d4709 upstream.

Avoid allocating memory and reading the host log when a virtual device
is used since this log is of no use to that driver. A virtual
device can be identified through the flag TPM_CHIP_FLAG_VIRTUAL, which
is only set for the tpm_vtpm_proxy driver.

Cc: stable@vger.kernel.org
Fixes: 6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -107,6 +107,9 @@ void tpm_bios_log_setup(struct tpm_chip
 	int log_version;
 	int rc = 0;
 
+	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
+		return;
+
 	rc = tpm_read_log(chip);
 	if (rc < 0)
 		return;


