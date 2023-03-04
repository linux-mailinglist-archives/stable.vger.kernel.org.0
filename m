Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233BE6AAAE3
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 16:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCDPlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 10:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCDPlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 10:41:37 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4707A1E5EA
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 07:41:36 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id l25so4916487wrb.3
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 07:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677944494;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5pvyLmp5wyo64q2XeD5TY4V9njcMxpvio2c4JP2y1r8=;
        b=qQiSG6IZRKz+oc1bByCIGQf/ISZXbcYmaUiAVsc8BohFTQim2j50EW7qCELChYXJ6+
         9Q9ml7Y8whY9aRSGgRHJvLfn/s+qNG+jAwOn4aF+iZCeLINRc4MiCuiSKanuroWqDZHq
         notX+H4jj7hTsMtZY/1D9TzH2Jj+aijpwdrzn8mOZ7p+bGmMtFD13a5Sh5O5dyAxEZAW
         UbC4oh2jSmfRzSxafCki06VxUoB/I4++dkdh3tLFwxthG4O3m9ALrGtyeiQs95ifsH/q
         R111gr5oTL2idkuoz9gEn+TNFOSd3Y9o316MALlvy7NBLj4PVK/wCAGxPFyU1OCXWCK3
         J6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677944494;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5pvyLmp5wyo64q2XeD5TY4V9njcMxpvio2c4JP2y1r8=;
        b=daW8oE77KhuL4DSPbM6RB0G7xsYQxL+8WZOmZ+eJeNV3F3k9yAcXberMKKm7klbxe7
         No9pbbXZZsMbfBj8Zizp9wpscyx6buqw/6vQBcW4yq4Jy676tjqNbNMWLQSzWRW2XPUJ
         zmrmWd5JqPHyP6MrFSUsGx2LXOzBU1cqCSC7vmyS9sr7proLGBO+FUt+SVIQbYCa/4Kk
         yReagyNw5AuLMIFzu/VlA1NvwoMTLdm5WN+OMNNiG7MmBn2v0CADz2hyPZ8fkUTP3/BL
         lJXs06JfWoOzwebW3EGnEzpgRsWr0b1yvBSvaEBKqQ3nKC1L/c4EJxlLgN+dIwEmIF1j
         1feQ==
X-Gm-Message-State: AO0yUKUuAAfh8qqriLaKiDqiq+Dxb/1PcQzoj9mOn1ULU8yXc8vDQzod
        TefeolPVNSSQhYZFn10Yr1RrbGZ2h6hI4dNh11XH6wbI3II=
X-Google-Smtp-Source: AK7set+woUmTJnDkC9bA0VZazT8nzcCOOh1GVLmH6mzkjuzjS3dBDw4/gqlTCggY7F+dLlij98D1BJRDH1AwzddF82o=
X-Received: by 2002:a5d:4805:0:b0:2c9:8df7:b385 with SMTP id
 l5-20020a5d4805000000b002c98df7b385mr1210068wrq.1.1677944494302; Sat, 04 Mar
 2023 07:41:34 -0800 (PST)
MIME-Version: 1.0
From:   Laurent Lyaudet <laurent.lyaudet@gmail.com>
Date:   Sat, 4 Mar 2023 16:41:23 +0100
Message-ID: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
Subject: Too many BDL entries regression
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Thanks for your hard work :)
Ubuntu 22.10 shipped kernel 5.19.0-35 thursday.
And some people started having syslogs :
"Too many BDL entries"
https://askubuntu.com/questions/1457367/snd-hda-intel-0000001f-3-too-many-bdl-entries-messages-in-system-log

I looked here how to report it :
https://docs.kernel.org/admin-guide/reporting-issues.html
and searched for "Too many BDL entries" but found nothing

I looked at versions here :
https://kernel.org/
but I don't know if version 5.19 should be reported at
stable@vger.kernel.org
since it is in between
5.15.98
and 6.1.15
or maybe Ubuntu does some renumbering ?

Excuse me if my report does not contain all needed data,
or should be addressed elsewhere.
Sorry if I cannot do all the checks with latest kernel ;
my current laptop is my only PC for work,
and I would prefer to avoid breaking it, even for a day or two.

Nevertheless, I would be happy to provide log extracts or other
information that may help.

Have a nice week-end, best regards,
    Laurent Lyaudet
