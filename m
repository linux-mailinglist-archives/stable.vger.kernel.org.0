Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDD66DC36E
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDJGGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 02:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJGGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 02:06:14 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B46A3C3C
        for <stable@vger.kernel.org>; Sun,  9 Apr 2023 23:06:12 -0700 (PDT)
Received: from [192.168.1.137] (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E10F1660309E
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 07:06:10 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681106771;
        bh=9FDI9pLqkTdAGq3/rfCzKWXwWJtDDi5lDMvTnOsa0Jo=;
        h=Date:To:From:Subject:From;
        b=PBwftCD+OxQwn3r5K8mVuFSkFiMMaTxpfa9D/ViB6qbtMFD1eIvrn05/o8T3oukG1
         IFBEZKG2z1yONLvQL0bDCnzcBa53zH1MFBvgIMlEdGHS8n5k4cjBkDDi1/3bZufIjp
         BEsEXrzr97vrulXitPl7SbI04mfLkBTw/ubnBvEpSmL42JTU0joODVWW0YUE5MlAZo
         rqdYflFrvo1A88iFhO0UvQ/hfq03hTaks8hwbeqsvUAk9lVRgH44MndhhV/jE0gh9T
         RgD09u6MJy8Lf7Ppi06m6B9HnIrsoqJKMPJeA1GevsM3gOzp9aeIzBoQn54fON5Q/P
         Tn+sZM82oe45Q==
Message-ID: <1fcff522-337a-c334-42a7-bc9b4f0daec4@collabora.com>
Date:   Mon, 10 Apr 2023 08:06:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     stable@vger.kernel.org
Content-Language: en-US
From:   =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>
Subject: stable-rc/linux-4.14.y bisection: baseline.login on meson8b-odroidc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Culprit: https://lore.kernel.org/r/20211227180026.4068352-2-martin.blumenstingl@googlemail.com

On lun 27-12-2021 19:00:24, Martin Blumenstingl wrote:
> The dt-bindings for the UART controller only allow the following values
> for Meson6 SoCs:
> - "amlogic,meson6-uart", "amlogic,meson-ao-uart"
> - "amlogic,meson6-uart"
>
> Use the correct fallback compatible string "amlogic,meson-ao-uart" for
> AO UART. Drop the "amlogic,meson-uart" compatible string from the EE
> domain UART controllers.

KernelCI detected that this patch introduced a regression in
stable-rc/linux-4.14.y (4.14.267) on a meson8b-odroidc1.
After this patch was applied the tests running on this platform don't
show any serial output.

This doesn't happen in other stable branches nor in mainline, but 4.14
hasn't still reached EOL and it'd be good to find a fix.

Here's the bisection report:
https://groups.io/g/kernelci-results/message/40147

KernelCI info:
https://linux.kernelci.org/test/case/id/64234f7761021a30b262f776/

Test log:
https://storage.kernelci.org/stable-rc/linux-4.14.y/v4.14.311-43-g88e481d604e9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html

Thanks,
Ricardo
