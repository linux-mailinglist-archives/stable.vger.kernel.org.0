Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F744BBA08
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbiBRNXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:23:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiBRNXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:23:05 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA4C25B2E9;
        Fri, 18 Feb 2022 05:22:47 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3FC0120005;
        Fri, 18 Feb 2022 13:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645190565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UJEWhVniuoP8Wv8IPEKZ0mxt7FVUl58XIp244xy2duY=;
        b=LzULFzHXsRRMF/aaeUa6mektFIhZ/f4dORt1x78hcfXZk8QMj48BuH8gh7qoyc6wfcHThY
        zhrt5FC4FAdBUMV3YeI9NOiNpSXdyoWP2+MPZ8TcIosg1qGrBg7UOYgDgQ+qg4yvRYpBth
        v+8+KxvTRGdZLKZYke3qEFEeqdJwnss38RIEmQDMkmPltaoPB6hegkO0F3oynxVYfL8OOX
        yHnsv9FKWxmRQLWLJwBMH/z8ewDRHmiRRyICIAikcrZLlGFK9bR4ZtIHZhqUdAHGOE6wgI
        Dquwt5s2PGZTUWEYb3u3Wuggoi3NK9KEHevrLyJG5F1cByqvFwD2YNNtRkbxOQ==
Date:   Fri, 18 Feb 2022 14:22:41 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christophe Kerello <christophe.kerello@foss.st.com>
Cc:     <richard@nod.at>, <vigneshr@ti.com>, <robh+dt@kernel.org>,
        <srinivas.kandagatla@linaro.org>, <p.yadav@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <devicetree@vger.kernel.org>, <chenshumin86@sina.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] mtd: core: Fix a conflict between MTD and NVMEM
 on wp-gpios property
Message-ID: <20220218142241.7a86aebb@xps13>
In-Reply-To: <20220217144755.270679-5-christophe.kerello@foss.st.com>
References: <20220217144755.270679-1-christophe.kerello@foss.st.com>
        <20220217144755.270679-5-christophe.kerello@foss.st.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Srinivas,

christophe.kerello@foss.st.com wrote on Thu, 17 Feb 2022 15:47:55 +0100:

> Wp-gpios property can be used on NVMEM nodes and the same property can
> be also used on MTD NAND nodes. In case of the wp-gpios property is
> defined at NAND level node, the GPIO management is done at NAND driver
> level. Write protect is disabled when the driver is probed or resumed
> and is enabled when the driver is released or suspended.
>=20
> When no partitions are defined in the NAND DT node, then the NAND DT node
> will be passed to NVMEM framework. If wp-gpios property is defined in
> this node, the GPIO resource is taken twice and the NAND controller
> driver fails to probe.
>=20
> A new Boolean flag named ignore_wp has been added in nvmem_config.
> In case ignore_wp is set, it means that the GPIO is handled by the
> provider. Lets set this flag in MTD layer to avoid the conflict on
> wp_gpios property.
>=20
> Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Cc: stable@vger.kernel.org

You can take patches 3 and 4 through the nvmem tree.

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,
Miqu=C3=A8l
