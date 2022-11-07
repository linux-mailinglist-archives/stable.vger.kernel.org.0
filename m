Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED661F957
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiKGQVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiKGQUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:20:39 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7262E205FF;
        Mon,  7 Nov 2022 08:20:11 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4CDDFC0005;
        Mon,  7 Nov 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667838010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1aiRW5byLVv6/Zl3rvmU1fUJuuBJRNLyImrDUKUB2A=;
        b=PqSYI2J5umJ9aOCxRT6hOtjzj77aTFCPbsuCgXWw7dhtGxA0jUBexLd7WFE8KMf0xzcIVB
        ODoTtwHPqIm/g7UyDV9IOVRvz6GRe4P4sosgRC5JSmEezC/iSZY2Xatv/srbBmor8NJj0B
        P+LbG8hfGB78+pu0VkfSnEw8irxJJQkPQMYrghUdpFJmk5uS3VNJWOg9YhJlhSqOLusXbT
        MsJhlZu4bIcQGgRuvCcYKUqxyfKLunlSet12gYaXvqL3sFTNzViV5emQJyFONlPjN8snod
        GD0LNj4paP8RqDYgc87qIdRWT72MZju2GagMpceqsf7mfEJOCRptms2Ek9YDPQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: raw: qcom_nandc: handle ret from parse with codeword_fixup
Date:   Mon,  7 Nov 2022 17:20:08 +0100
Message-Id: <20221107162008.44113-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021165304.19991-1-ansuelsmth@gmail.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'7df140e84a75c89962feef659d686303d3ce75e5'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-10-21 at 16:53:04 UTC, Christian Marangi wrote:
> With use_codeword_fixup enabled, any return from
> mtd_device_parse_register gets overwritten. Aside from the clear bug, this
> is also problematic as a parser can EPROBE_DEFER and because this is not
> correctly handled, the nand is never rescanned later in the bootup
> process.
> 
> An example of this problem is when smem requires additional time to be
> probed and nandc use qcomsmempart as parser. Parser will return
> EPROBE_DEFER but in the current code this ret gets overwritten by
> qcom_nand_host_parse_boot_partitions and qcom_nand_host_init_and_register
> return 0.
> 
> Correctly handle the return code from mtd_device_parse_register so that
> any error from this function is not ignored.
> 
> Fixes: 862bdedd7f4b ("mtd: nand: raw: qcom_nandc: add support for unprotected spare data pages")
> Cc: stable@vger.kernel.org # v6.0+
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
