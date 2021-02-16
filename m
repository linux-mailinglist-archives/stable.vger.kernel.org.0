Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B60231D129
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhBPTsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:48:35 -0500
Received: from mout.gmx.net ([212.227.17.22]:49771 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBPTse (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 14:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613504810;
        bh=KqNmGOfBolWBBQNx0fdVy8+tHxOAeoJw3Nc3OAYv8BE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=XNPkEi1jXJlZQYizvVJ5XVuEjtQjOg+hqJsaLIONlxtfS2FEleewmONPPMaBuzAu9
         QJmnTbzLzMUn75jqhgy1NVSypWVfp2f6ioR9DUyOeZ39NVH4G4X5fjXtuluIiF6bJL
         9VGfK37yLAbIs1nP5Omh/ynue7BdrnyO0P8XNlT0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIdif-1l6rVf0193-00EfA5; Tue, 16
 Feb 2021 20:46:50 +0100
Subject: Re: [PATCH v5] The following sequence of operations results in a
 refcount warning:
To:     peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca
Cc:     stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        David.Laight@ACULAB.COM, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613504532-4165-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613504532-4165-2-git-send-email-LinoSanfilippo@gmx.de>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <6359614f-b574-9911-e55d-52a39f5e0ea4@gmx.de>
Date:   Tue, 16 Feb 2021 20:46:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1613504532-4165-2-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:f5HNPEWMGz0C8nYsBS4Zb2phv5KS0BzeCK2+YVjSyKVAiG2DJcg
 Ka3bzaU53nraL3OkOpo+BBM+fry0KP9G8VvlX/U9F3W99lIhPFsZwZeFINnNIobpChsz8xG
 7V3Nsq+6qB7Q2N8BLUQzeHjM91uv+gB6R2BN0moP74Kfioz+n0/DwTRubGa0VGNmySc3NS5
 o1afpyz3B6wht8ixEWnBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vtRtZsBZhQ0=:FI7/Hnoe+2YymhcayBp8P/
 h/SxrFFGa+Qih+TgTiBGNHUoWuEn4/8LMch6GariBjLH2G9XfmXSDKfahBNMLfzFFaPO4JJyF
 lNn/ALfecLDGs4oCSPByIATIZYk6e+ewRBR/PFBiQNJSDPP4b/7qUruojEpU/ggGDRte27joF
 47Zno1E8Lgd8ZdHNMzet8uy7S21Lqks2Hhcgg+USI3sn5o5oS5vv916gIJjqL7Ut08YnDg9sQ
 Y445MOYFofYjPFswr0tfbFX8zY8PBrTq5XJmlR7xpum9gTS5hzIO5qFOfNymfLaQMNcf3bDJr
 8q/RDu3keqnY3YU23yN0mrGglp97AvP7wqDz5l40W03XCU1ZYL5hU5rVBwb2e+BJn0BIqqwA5
 wr86sOXJ1iE1Hc7bK1O8Ebdw5bjQ77V47UqAtGmM/O9YOnOKC5Q0zAGgcUu02IPlv9G5A7ciu
 KSZEYv/1+skq5xb7/FG1CP620yq33dUEGWYGq+W8uOvRaTzU2X2jG9js6dIc5QdYqoLUnhO5H
 Yn8iK1SuuulKIHbFTo0FqGofeAmIW2BOZoMz6ZvFYhqDat5wAyxBnJxnTVD6sKmOjXvVE6whL
 a4ECZhntdtUY1W57OxdaM6e85i/Q0QD1xpWhwGlBkzznWWcgay3btg8cW5V/D8A58Y1XtPgyH
 Ybv1W+aSOzEktuq/r94jYY6VwLLauM2NWhT7Xh1fGaiJH3qWAUxZbTrHN6l1ktzA59hGYmX5w
 AMaB3qrNiyCNufa2Tj9bEtFMCzIFBUG+iETP4G2IZS58dPBaH/1ZcH6JIwwuov6apx/vxC8k4
 yjj1TiHOc0JXYXo/pyYbNIkGWqW0rDLypTs6lqMYT5Na3HQORsyKfT+xECisS7c7D3+q30N1q
 uuGzZdHvfauYAOev8hbg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Please ignore this patch, I somehow managed to cut off the head line.
I will resend it shorty.

Regards,
Lino
