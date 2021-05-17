Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07F3383279
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbhEQOsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241782AbhEQOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA9161966;
        Mon, 17 May 2021 14:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261292;
        bh=jSsfYsjOAK5vnwE44c3ptQAHVaPrn3/ES+jLwvO6c4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzEZ3lUunYkD8cr7Cs3wRB7f9G+jUxii6/NDmireakQTpV1yEjjzWPQbynLcvyPvS
         4VMze7+PRaW9FsU0ISS8WG1R7hk/2ya+fctBrEoOcZT2ZYPf4Q/R+IenVTWDRyxzjU
         6A6OH4IqSEEh7zbU1yn6JjGL2/zG9rvlRLslNvcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 002/289] tpm: fix error return code in tpm2_get_cc_attrs_tbl()
Date:   Mon, 17 May 2021 15:58:47 +0200
Message-Id: <20210517140305.229967916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 1df83992d977355177810c2b711afc30546c81ce upstream.

If the total number of commands queried through TPM2_CAP_COMMANDS is
different from that queried through TPM2_CC_GET_CAPABILITY, it indicates
an unknown error. In this case, an appropriate error code -EFAULT should
be returned. However, we currently do not explicitly assign this error
code to 'rc'. As a result, 0 was incorrectly returned.

Cc: stable@vger.kernel.org
Fixes: 58472f5cd4f6("tpm: validate TPM 2.0 commands")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -656,6 +656,7 @@ int tpm2_get_cc_attrs_tbl(struct tpm_chi
 
 	if (nr_commands !=
 	    be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE + 5])) {
+		rc = -EFAULT;
 		tpm_buf_destroy(&buf);
 		goto out;
 	}


