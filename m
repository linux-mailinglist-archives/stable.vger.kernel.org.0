Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8315A28F3
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 15:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344439AbiHZN4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 09:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344441AbiHZN40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 09:56:26 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971C8C121F
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 06:56:05 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-33dc345ad78so38010287b3.3
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 06:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc;
        bh=/+D0ouh68eK9xYu8CElI6RKcjd9YgIjMhev4HA1gDV4=;
        b=LzpkvFFqiMnNVMR1rWvXbDDkGW3wnxMjCErrD9ldjW8ktT+2aUB8CqpfU5kVlOuxeE
         vn2Eu2SEcLZpQM6+Xwt2l/ENkrB4lcjd/jOB6E2F7xjDkDP8C3BYOFzlcDS6xZDYEu2E
         6aXO/ka/phg52hAxuKSVIQeJ4HZETq1EBN18rUqmbeZudKOZeqOXp80in/ybS8GZ5A0Q
         wkbg7RfGQ1+U6tXXlJaPIYyIilwDAyd3toVVx/d2a2rWL3nh7+qabXbhnBa4qLH0M1CH
         viIqV+QW9KLJ7SFuf9SpBfsGwO0kna8+ZaxNVSsrkatJJw37OuWBpwMf3at95SPXBpFl
         IZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/+D0ouh68eK9xYu8CElI6RKcjd9YgIjMhev4HA1gDV4=;
        b=XaX6D1gOPxNGunOPGUvYkrM99NG3FCPa+BtB+Qf3vflfbFa/HjIYs8hCRflNVgT0V6
         h1gWrdgvB9i4K8Fdkb6kX/2qkjIYiiWYHL6AVvQX8PcwDFC5e2tiLxV6/iZRYZL4GThV
         yrW7V9cpHAnjKutxtc2xVQU+4BjiGdmLaYtai0R5eluz+p506iEtq04ngAxW1fIQ0nOK
         PXNduee79SQ7pRJTwKxIaP36EaDXwQoe7Kqe8TFbEytXEmWolgrPK8iTLwXL65jH72le
         2Kx0OCYwRt5osVCDkYKfhWZ/f9yoKvwYXPJ3Holvt5D1sz5P0T5HcHTxmKchPUhzTQAK
         a1mg==
X-Gm-Message-State: ACgBeo3R7SL9cFrpzpF3ymZGgXfafCEQ7azCnHzqVTg7Jjugm/2xfyuJ
        Y9TYF23ZByIJsp+KKBgE9lD9mjnF28Psbw2CqFoWi8DAmdt1
X-Google-Smtp-Source: AA6agR5oJk7rz4g+6N0UDnPRGIk/Z7M3lSty2e4Ask2DTIFO50dPn4Tbm0sNRzX5Nh+u18fog91wfQbcnJFay3QfD4Y=
X-Received: by 2002:a0d:cac2:0:b0:339:6ecd:e9a6 with SMTP id
 m185-20020a0dcac2000000b003396ecde9a6mr9537294ywd.156.1661522164552; Fri, 26
 Aug 2022 06:56:04 -0700 (PDT)
MIME-Version: 1.0
From:   Urja Rannikko <urjaman@gmail.com>
Date:   Fri, 26 Aug 2022 16:55:55 +0300
Message-ID: <CAPCnQJm+M4Sm_gAA6vKK5jRnwp8etsaA+gx07HqPS-v8GjqnuA@mail.gmail.com>
Subject: [regression] build failure of smsc95xx since 5.15.61
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, lukas@wunner.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Here's the relevant bit of the build log:
drivers/net/usb/smsc95xx.c: In function =E2=80=98smsc95xx_status=E2=80=99:
drivers/net/usb/smsc95xx.c:625:3: error: implicit declaration of
function =E2=80=98generic_handle_domain_irq=E2=80=99; did you mean
=E2=80=98generic_handle_irq=E2=80=99? [-Werror
=3Dimplicit-function-declaration]
  625 |   generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~
      |   generic_handle_irq
drivers/net/usb/smsc95xx.c: In function =E2=80=98smsc95xx_bind=E2=80=99:
drivers/net/usb/smsc95xx.c:1136:21: error: implicit declaration of
function =E2=80=98irq_domain_alloc_named_fwnode=E2=80=99
[-Werror=3Dimplicit-function-declaration
]
 1136 |  pdata->irqfwnode =3D irq_domain_alloc_named_fwnode(usb_path);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/usb/smsc95xx.c:1136:19: warning: assignment to =E2=80=98struct
fwnode_handle *=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from inte=
ger without a cast
[-Wint-co
nversion]
 1136 |  pdata->irqfwnode =3D irq_domain_alloc_named_fwnode(usb_path);
      |                   ^
drivers/net/usb/smsc95xx.c:1142:21: error: implicit declaration of
function =E2=80=98irq_domain_create_linear=E2=80=99
[-Werror=3Dimplicit-function-declaration]
 1142 |  pdata->irqdomain =3D irq_domain_create_linear(pdata->irqfwnode,
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/usb/smsc95xx.c:1144:12: error: =E2=80=98irq_domain_simple_ops=
=E2=80=99
undeclared (first use in this function); did you mean
=E2=80=98irq_domain_ops=E2=80=99?
 1144 |           &irq_domain_simple_ops,
      |            ^~~~~~~~~~~~~~~~~~~~~
      |            irq_domain_ops
drivers/net/usb/smsc95xx.c:1144:12: note: each undeclared identifier
is reported only once for each function it appears in
drivers/net/usb/smsc95xx.c:1151:12: error: implicit declaration of
function =E2=80=98irq_create_mapping=E2=80=99; did you mean =E2=80=98irq_di=
spose_mapping=E2=80=99?
[-Werror=3Dimp
licit-function-declaration]
 1151 |  phy_irq =3D irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
      |            ^~~~~~~~~~~~~~~~~~
      |            irq_dispose_mapping
drivers/net/usb/smsc95xx.c:1245:2: error: implicit declaration of
function =E2=80=98irq_domain_remove=E2=80=99 [-Werror=3Dimplicit-function-d=
eclaration]
 1245 |  irq_domain_remove(pdata->irqdomain);
      |  ^~~~~~~~~~~~~~~~~
drivers/net/usb/smsc95xx.c:1248:2: error: implicit declaration of
function =E2=80=98irq_domain_free_fwnode=E2=80=99; did you mean
=E2=80=98irq_domain_get_of_node=E2=80=99? [-Werr
or=3Dimplicit-function-declaration]
 1248 |  irq_domain_free_fwnode(pdata->irqfwnode);
      |  ^~~~~~~~~~~~~~~~~~~~~~
      |  irq_domain_get_of_node
drivers/net/usb/smsc95xx.c: In function =E2=80=98smsc95xx_unbind=E2=80=99:
drivers/net/usb/smsc95xx.c:1262:22: error: implicit declaration of
function =E2=80=98irq_find_mapping=E2=80=99; did you mean =E2=80=98irq_disp=
ose_mapping=E2=80=99?
[-Werror=3Dimpli
cit-function-declaration]
 1262 |  irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ))=
;
      |                      ^~~~~~~~~~~~~~~~
      |                      irq_dispose_mapping


The build is for 32-bit x86, the defconfig can be found here:
https://github.com/urjaman/i586con/blob/master/brext/board/linux.config

The build failure also happens with 5.15.62 and 63.

--=20
Urja Rannikko
