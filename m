Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DF550995E
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 09:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385842AbiDUHic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 03:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385887AbiDUHiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 03:38:24 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B847D13DD3;
        Thu, 21 Apr 2022 00:35:31 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 55E7A1C000F;
        Thu, 21 Apr 2022 07:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650526529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4QO0moKpEkXz+ulrvSLQo0T9lC8TOEa3gAblMHHWcg=;
        b=W5tjJw+uF9lptPqXryNnTwotnKABgq9Ic3j79bCDlyH4iFgliXcsv9VSd7n99CplsWqHCq
        okVua35NKDn/cOEwdtfhzT3+mokU0WhN1lah0wBVHe3nqb6em5PDNp5vJtLwKz6yXV+Zgw
        vrf9KgFxLeQlocnMMpzXJHdG54xIiL887VIpXmBbT5sw8omtoMXb0CzImEZkf7fQPOs8iz
        HmgZr3qiTBbVnufIUcXIru9Cy+I0hPCyWbZa4qVPZbVclAW+xG73nDp16a9J9YYzuyj0j3
        Rd/slS5Gex4c2ycFMo2uZ3M9C51cMLv3LXCpbG7V+b7WX2aJimX71A4eDWNpwQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Md Sadre Alam <quic_mdalam@quicinc.com>, mani@kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.dybcio@somainline.org, quic_srichara@quicinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V5] mtd: rawnand: qcom: fix memory corruption that causes panic
Date:   Thu, 21 Apr 2022 09:35:27 +0200
Message-Id: <20220421073527.71690-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <1650268107-5363-1-git-send-email-quic_mdalam@quicinc.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'ba7542eb2dd5dfc75c457198b88986642e602065'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-04-18 at 07:48:27 UTC, Md Sadre Alam wrote:
> This patch fixes a memory corruption that occurred in the
> nand_scan() path for Hynix nand device.
> 
> On boot, for Hynix nand device will panic at a weird place:
> | Unable to handle kernel NULL pointer dereference at virtual
>   address 00000070
> | [00000070] *pgd=00000000
> | Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> | Modules linked in:
> | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-01473-g13ae1769cfb0
>   #38
> | Hardware name: Generic DT based system
> | PC is at nandc_set_reg+0x8/0x1c
> | LR is at qcom_nandc_command+0x20c/0x5d0
> | pc : [<c088b74c>]    lr : [<c088d9c8>]    psr: 00000113
> | sp : c14adc50  ip : c14ee208  fp : c0cc970c
> | r10: 000000a3  r9 : 00000000  r8 : 00000040
> | r7 : c16f6a00  r6 : 00000090  r5 : 00000004  r4 :c14ee040
> | r3 : 00000000  r2 : 0000000b  r1 : 00000000  r0 :c14ee040
> | Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment none
> | Control: 10c5387d  Table: 8020406a  DAC: 00000051
> | Register r0 information: slab kmalloc-2k start c14ee000 pointer offset
>   64 size 2048
> | Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
> | nandc_set_reg from qcom_nandc_command+0x20c/0x5d0
> | qcom_nandc_command from nand_readid_op+0x198/0x1e8
> | nand_readid_op from hynix_nand_has_valid_jedecid+0x30/0x78
> | hynix_nand_has_valid_jedecid from hynix_nand_init+0xb8/0x454
> | hynix_nand_init from nand_scan_with_ids+0xa30/0x14a8
> | nand_scan_with_ids from qcom_nandc_probe+0x648/0x7b0
> | qcom_nandc_probe from platform_probe+0x58/0xac
> 
> The problem is that the nand_scan()'s qcom_nand_attach_chip callback
> is updating the nandc->max_cwperpage from 1 to 4 or 8 based on page size.
> This causes the sg_init_table of clear_bam_transaction() in the driver's
> qcom_nandc_command() to memset much more than what was initially
> allocated by alloc_bam_transaction().
> 
> This patch will update nandc->max_cwperpage 1 to 4 or 8 based on page
> size in qcom_nand_attach_chip call back after freeing the previously
> allocated memory for bam txn as per nandc->max_cwperpage = 1 and then
> again allocating bam txn as per nandc->max_cwperpage = 4 or 8 based on
> page size in qcom_nand_attach_chip call back itself.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6a3cec64f18c ("mtd: rawnand: qcom: convert driver to nand_scan()")
> Reported-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Co-developed-by: Sricharan R <quic_srichara@quicinc.com>
> Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
> Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
