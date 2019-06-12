Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8043145
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390632AbfFLU5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 16:57:11 -0400
Received: from namei.org ([65.99.196.166]:38730 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389007AbfFLU5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 16:57:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x5CKv9HT002356;
        Wed, 12 Jun 2019 20:57:09 GMT
Date:   Thu, 13 Jun 2019 06:57:09 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Milan Broz <gmazyland@gmail.com>
cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix null pointer dereference on chip register error
 path
In-Reply-To: <20190612084210.13562-1-gmazyland@gmail.com>
Message-ID: <alpine.LRH.2.21.1906130656590.1778@namei.org>
References: <20190612084210.13562-1-gmazyland@gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Jun 2019, Milan Broz wrote:

> If clk_enable is not defined and chip initialization
> is canceled code hits null dereference.
> 
> Easily reproducible with vTPM init fail:
>   swtpm chardev --tpmstate dir=nonexistent_dir --tpm2 --vtpm-proxy
> 
> BUG: kernel NULL pointer dereference, address: 00000000
> ...
> Call Trace:
>  tpm_chip_start+0x9d/0xa0 [tpm]
>  tpm_chip_register+0x10/0x1a0 [tpm]
>  vtpm_proxy_work+0x11/0x30 [tpm_vtpm_proxy]
>  process_one_work+0x214/0x5a0
>  worker_thread+0x134/0x3e0
>  ? process_one_work+0x5a0/0x5a0
>  kthread+0xd4/0x100
>  ? process_one_work+0x5a0/0x5a0
>  ? kthread_park+0x90/0x90
>  ret_from_fork+0x19/0x24
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> Cc: stable@vger.kernel.org


Reviewed-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

