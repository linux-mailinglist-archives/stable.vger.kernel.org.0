Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7193E6C71D9
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 21:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjCWUt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 16:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCWUt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 16:49:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1B92
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so3317835pjz.1
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1679604597;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1Uul858JFOc4slgtlzEor7kzW5IkLa0my4yRuVlvyQ=;
        b=ZCCwxjIDJyAzWKJ4Dm7q8drS9iIvM0hjIlFZuu891sZNYdObjxpAQMuckoUN5NAbod
         YfsEbbaDONhPM7Gqjse5lp2T7AWHg/UwjE0efOKZ4M7QsxrkVdTLfGl+nkQQ24U00u7b
         AhurTzPzIu3NZmfHmSWY4/Lmk6XJR0rEqc1iG0IwRBBoYzIIv0bSfHVeo9kRvaHE2r35
         WwHqt2/1RqKrwGMlkg1jn2UTCxtk2tgjsliotC+l2fhl9KYskZlkSf4gmIvuROsrdi+6
         XJGvqHr0+DRJST5E/4OLo1B3GMd6YPsqe31xigKppOA4tAqZcwQo6K5v34F/DmvscknR
         zJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679604597;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1Uul858JFOc4slgtlzEor7kzW5IkLa0my4yRuVlvyQ=;
        b=ufHmR96LINq4w64NxC0O+Cc12ZY42aHmlJJnphzRfXEoQQOnFbROq04eYkUbuuGlem
         WKaY5cMU/iOX93Xp0FkR6IaMg8n06G3ZQtMM4lkgE+h11ivo6azraiOFkY8EdQFkYDyW
         BKjo0mjS6kMBQAMC6MXVQGXk5Fkkv+tTsQUbuRVpR3IAZcOkd7ImrY9TfKROEAoeNmbV
         yShSPYrcf4ExYxyCx/UJNWVzzjftLbl8UdEHwusZhTU1xG0THkZ1XdXVdtcF6cQrIHp8
         fDnsC49pM34cC8y4wzvp9fmlgN/o38dllEm0rVmenOHOW8NfqwrgwtvRdbhBqPuXMEl1
         74BQ==
X-Gm-Message-State: AAQBX9cwqzJhcVV87ZRYACJDBmeuunclNTnfFac3a1L4rGgKSe5PBEre
        65XzRAzGIeCBCLxiSPBMta+2Hw==
X-Google-Smtp-Source: AKy350Zr1GRzGFoiPnXthakhzlVrWQ27tcYR20J9buwGWiDH1AccoQsn0StymwoAZeIzzNdJrKdc9w==
X-Received: by 2002:a17:90b:4d81:b0:23b:3422:e78a with SMTP id oj1-20020a17090b4d8100b0023b3422e78amr372422pjb.6.1679604597027;
        Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902789200b00185402cfedesm12757133pll.246.2023.03.23.13.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 13:49:56 -0700 (PDT)
In-Reply-To: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
References: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
Subject: Re: [PATCH] riscv: Handle zicsr/zifencei issues between clang and
 binutils
Message-Id: <167960451913.18089.10045388605224266027.b4-ty@rivosinc.com>
Date:   Thu, 23 Mar 2023 13:48:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-901c5
Cc:     ndesaulniers@google.com, trix@redhat.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, aou@eecs.berkeley.edu,
        Conor Dooley <conor.dooley@microchip.com>,
        Nathan Chancellor <nathan@kernel.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Mon, 13 Mar 2023 16:00:23 -0700, Nathan Chancellor wrote:
> There are two related issues that appear in certain combinations with
> clang and GNU binutils.
> 
> The first occurs when a version of clang that supports zicsr or zifencei
> via '-march=' [1] (i.e, >= 17.x) is used in combination with a version
> of GNU binutils that do not recognize zicsr and zifencei in the
> '-march=' value (i.e., < 2.36):
> 
> [...]

Applied, thanks!

[1/1] riscv: Handle zicsr/zifencei issues between clang and binutils
      https://git.kernel.org/palmer/c/e89c2e815e76

Best regards,
-- 
Palmer Dabbelt <palmer@rivosinc.com>

