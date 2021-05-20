Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56038A2B8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhETJpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhETJm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB03613D9;
        Thu, 20 May 2021 09:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503157;
        bh=CLNenmTL0h3stCXgHi3YgfaI2pJeN5bOqxxcUvBZmAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDZTkT/GyHWz74JEEJ5YIv0p0iVy7B4oL0b4g52YUdZlNUqKUljIQqbYAAftUaxyl
         OLWkuNNYShfCSzw7Zb5ujdPg4u3iufcRcD2nOu8YRYF3VDVgOyYbQFWBhp3WIpx/9b
         Xkmwl3DNclG131022zjVPKGACLwXQZpWpvEgmh3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.19 094/425] tpm: vtpm_proxy: Avoid reading host log when using a virtual device
Date:   Thu, 20 May 2021 11:17:43 +0200
Message-Id: <20210520092134.547727177@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -112,6 +112,9 @@ void tpm_bios_log_setup(struct tpm_chip
 	int log_version;
 	int rc = 0;
 
+	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
+		return;
+
 	rc = tpm_read_log(chip);
 	if (rc < 0)
 		return;


