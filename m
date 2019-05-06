Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2914BEE
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEFOeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfEFOeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15BCB204EC;
        Mon,  6 May 2019 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153264;
        bh=Dy+I8rsDbFZauPhRvbkfbHNORIdzXayt9jJPqi/2LOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ0by/w8+HvrszFna+yDXTQdRS9iJNKzJV5cKgIKRpkHMcQB0z6YL7XgX/PStIz+2
         nUb84OMLvegcjC6mgVLDEABmifPbS+YbLnuKKiN3/wv33nBjugBvzmP39911boSiir
         k782lt3wPsEaBy9lVw14MYw8haVYBJNpWsBhWqoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.0 008/122] i2c: synquacer: fix enumeration of slave devices
Date:   Mon,  6 May 2019 16:31:06 +0200
Message-Id: <20190506143055.458618424@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 95e0cf3caeb11e1b0398c747b5cfa12828263824 upstream.

The I2C host driver for SynQuacer fails to populate the of_node and
ACPI companion fields of the struct i2c_adapter it instantiates,
resulting in enumeration of the subordinate I2C bus to fail.

Fixes: 0d676a6c4390 ("i2c: add support for Socionext SynQuacer I2C controller")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-synquacer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -602,6 +602,8 @@ static int synquacer_i2c_probe(struct pl
 	i2c->adapter = synquacer_i2c_ops;
 	i2c_set_adapdata(&i2c->adapter, i2c);
 	i2c->adapter.dev.parent = &pdev->dev;
+	i2c->adapter.dev.of_node = pdev->dev.of_node;
+	ACPI_COMPANION_SET(&i2c->adapter.dev, ACPI_COMPANION(&pdev->dev));
 	i2c->adapter.nr = pdev->id;
 	init_completion(&i2c->completion);
 


