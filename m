Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC62DAA01
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgLOJX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgLOJXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 04:23:48 -0500
Date:   Tue, 15 Dec 2020 10:24:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608024188;
        bh=IsO2yS/ol3Xi+Mbk1GmVVXTDvXEoYtREmj3diwOFMSk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=zNeUTfZr1nQSN/XBa/1aMoTKhO4A6YXJwXPyoTsMZk0bSsR3vV2IYejiD33oRPbh1
         z9iAetQA6qHLqsb5M0bP9puw8q3EhmytWOab2elCx7SutaoeixvDdLNsvUxfV+/rp2
         XKIj3vj8QDurDf/ymaM+F6AVjfJE4F0skqSjz0nk=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shan <chenshan@hygon.cn>
Cc:     alikernel-developer@linux.alibaba.com,
        Roberto Sassu <roberto.sassu@huawei.com>, mayuanchen@hygon.cn,
        fenghao@hygon.cn, yingzhiwei@hygon.cn, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH AliOS 4.19 v3 11/15] KEYS: trusted: allow module init if
 TPM is inactive or deactivated
Message-ID: <X9iAuzeS1wJDPVLg@kroah.com>
References: <cover.1608019826.git.chenshan@hygon.cn>
 <a28cb67324fee8afabc7912f5045788e74e0aff9.1608019826.git.chenshan@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a28cb67324fee8afabc7912f5045788e74e0aff9.1608019826.git.chenshan@hygon.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 04:29:18PM +0800, Shan wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> commit 2d6c25215ab26bb009de3575faab7b685f138e92 upstream.
> 
> Commit c78719203fc6 ("KEYS: trusted: allow trusted.ko to initialize w/o a
> TPM") allows the trusted module to be loaded even if a TPM is not found, to
> avoid module dependency problems.
> 
> However, trusted module initialization can still fail if the TPM is
> inactive or deactivated. tpm_get_random() returns an error.
> 
> This patch removes the call to tpm_get_random() and instead extends the PCR
> specified by the user with zeros. The security of this alternative is
> equivalent to the previous one, as either option prevents with a PCR update
> unsealing and misuse of sealed data by a user space process.
> 
> Even if a PCR is extended with zeros, instead of random data, it is still
> computationally infeasible to find a value as input for a new PCR extend
> operation, to obtain again the PCR value that would allow unsealing.
> 
> Cc: stable@vger.kernel.org
> Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
> Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Signed-off-by: mayuanchen <mayuanchen@hygon.cn>
> Change-Id: Iada0e052c2ab4a0fbc2db4ac2690da3115d985c6
> Signed-off-by: Shan <chenshan@hygon.cn>
> ---
>  security/keys/trusted.c | 13 -------------
>  1 file changed, 13 deletions(-)

Why is this being sent to the stable list?  Do you want this backported
to 4.19.y?  If so, why, and what is the change-id stuff in there for?

confused,

greg k-h
