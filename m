Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061E253087B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 06:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiEWEpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 00:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiEWEpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 00:45:35 -0400
X-Greylist: delayed 343 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 May 2022 21:45:33 PDT
Received: from mail.jv-coder.de (mail.jv-coder.de [5.9.79.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F308E7C
        for <stable@vger.kernel.org>; Sun, 22 May 2022 21:45:33 -0700 (PDT)
Received: from [192.168.178.40] (unknown [188.192.100.83])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 545DA9FB6D;
        Mon, 23 May 2022 04:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1653280787; bh=6iwiZOc1Z6dW3zw+cVqpDwD8q7C0y1FvocYFbkYIZgk=;
        h=Message-ID:Date:MIME-Version:To:From:Subject;
        b=g6i1NI+1fE1Y1/D8Yjcr/rR1VkPE5/3+gKMgt/DaNIycE2wCFzCe4vyF9fVga3G22
         OQfNmaClFERn4jO3hrn/lNDvrC61btCo9E87BsHqZllAQsV5uXG4a9zXgCAb5U8fNC
         wySgqtTG/8kwaGGchYcEAvRacV3/vj7DdSa+Gl8c=
Message-ID: <342c6a9f-771f-0714-e02c-08d0c0f4cd6b@jv-coder.de>
Date:   Mon, 23 May 2022 06:39:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     linux-stable <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
From:   Joerg Vehlow <lkml@jv-coder.de>
Subject: [PATCH 5.10] module: treat exit sections the same as init sections
 when !CONFIG_MODULE_UNLOAD
Cc:     Joerg Vehlow <joerg.vehlow@aox.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this mainline patch 33121347fb1c359bd6e3e680b9f2c6ced5734a8 should be
applied to 5.15 as well.
Without loading of some modules fails, if
 1. MODULE_UNLOAD=n
 2. Architecture is aarch64 (maybe others as well)
 3. KASLR is active

Without this patch the symbol .exit.text is not relocated and when the
linker generated a relative 32 bit relocation(PREL32) and the module is
loaded far enough away from the default loading address, it will trigger
a relocation overflow like this:

module algif_hash: overflow in relocation type 261 val ffff800010051c20

This happens to all modules, that use BUG in the exit section or if the
compiler generates a jump table in the exit section.

Thanks,
Joerg
