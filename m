Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05A45BEF3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344830AbhKXMw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345708AbhKXMuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:50:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E1D61354;
        Wed, 24 Nov 2021 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756985;
        bh=W0nAlYZtCLw8AcLRXHf2QHJYQKytd+u2vhcbJ9GOszs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vckapUhLXMsbXB36EzZKi8DxUZTmOJM3MhpfYjrdALiZARbgn1qtiFGnH4jHVi5R8
         ekK9+Yx4LY1cq4WWYt11KswtHjZYiyOFrwpEJ3aHWYPak7aAGO+oH5YZFc8JWZLC56
         vBFvcR/gmL6iQ61dPa5p4rXOiOPGC38VozXtDhew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.19 010/323] tpm: Check for integer overflow in tpm2_map_response_body()
Date:   Wed, 24 Nov 2021 12:53:20 +0100
Message-Id: <20211124115719.177572246@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a0bcce2b2a169e10eb265c8f0ebdd5ae4c875670 upstream.

The "4 * be32_to_cpu(data->count)" multiplication can potentially
overflow which would lead to memory corruption.  Add a check for that.

Cc: stable@vger.kernel.org
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-space.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -419,6 +419,9 @@ static int tpm2_map_response_body(struct
 	if (be32_to_cpu(data->capability) != TPM2_CAP_HANDLES)
 		return 0;
 
+	if (be32_to_cpu(data->count) > (UINT_MAX - TPM_HEADER_SIZE - 9) / 4)
+		return -EFAULT;
+
 	if (len != TPM_HEADER_SIZE + 9 + 4 * be32_to_cpu(data->count))
 		return -EFAULT;
 


