Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A814052E726
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 10:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346925AbiETITb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 04:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbiETITa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 04:19:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC113C4CE;
        Fri, 20 May 2022 01:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3021BB828BD;
        Fri, 20 May 2022 08:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE25C385A9;
        Fri, 20 May 2022 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653034766;
        bh=QnYs/lpQnJXDQEWmgsOJd8Vu9tHGE2IfGI8AaoYYcgs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UfX1z06R+Q0JPwMlW5LBpXpLMqCX2SiX9s+vR4PP/5F0GTWKudkP9p0Bm7mtvpHjC
         8sfUc2QT/zIybKDhckTt2eBKLLtQtWdsF8WaI0FpuGuTBz4OLGvPSxd9mM6ON0xk1t
         rx6wSL4YgEcPPvCIE+q5qe/NbApWTN5VtpsRAjYoMlPYIS+IZf+XKL8cHCl4s0sFy+
         7E/IBCkMdZSkmL+1U3llgLJiN10f8PNbKoqeXM1fM6jokt9oMdyDFNVYGOGzqupa5W
         QImllHcWgaq9+JK2La8aFcrj7ICR5ji3i2ZFOg0QgNp4nXSuqfPEzzVxuZ1xivALBq
         FqnV1C9Kvz3AQ==
Received: by mail-wr1-f53.google.com with SMTP id r30so10407941wra.13;
        Fri, 20 May 2022 01:19:25 -0700 (PDT)
X-Gm-Message-State: AOAM530ifU07k1evNtDC8+ZawGfx+oQYax4O+EHeI+PbA1GreCwaD3VX
        H5tareAQN3zUQd9TNkjiW7sm1nYZW6GJCNSeeCY=
X-Google-Smtp-Source: ABdhPJwNV0yJMvGmlO8rWymfGpmxhMyB65SD1f4lbVs62dI0YLtxQbjYpwFqmvHjg/LJxfFqTeRGlPbX0ecGnZNWpB4=
X-Received: by 2002:a5d:6286:0:b0:20d:9b5:6a97 with SMTP id
 k6-20020a5d6286000000b0020d09b56a97mr7297948wru.165.1653034764201; Fri, 20
 May 2022 01:19:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Fri, 20 May 2022 01:19:23
 -0700 (PDT)
In-Reply-To: <20220520053547.29034-1-hyc.lee@gmail.com>
References: <20220520053547.29034-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 May 2022 17:19:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-X6deq3fuYHD7LZgXNQ=gTfXUkL2z02YjC6+C=arRhMQ@mail.gmail.com>
Message-ID: <CAKYAXd-X6deq3fuYHD7LZgXNQ=gTfXUkL2z02YjC6+C=arRhMQ@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fix outstanding credits related bugs
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-05-20 14:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> outstanding credits must be initialized to 0,
> because it means the sum of credits consumed by
> in-flight requests.
> And outstanding credits must be compared with
> total credits in smb2_validate_credit_charge(),
> because total credits are the sum of credits
> granted by ksmbd.
>
> This patch fix the following error,
> while frametest with Windows clients:
>
> Limits exceeding the maximum allowable outstanding requests,
> given : 128, pending : 8065
>
> Fixes: b589f5db6d4a ("ksmbd: limits exceeding the maximum allowable
> outstanding requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Reported-by: Yufan Chen <wiz.chen@gmail.com>
> Tested-by: Yufan Chen <wiz.chen@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
