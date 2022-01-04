Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196D484AC7
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 23:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiADWeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 17:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiADWeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 17:34:03 -0500
X-Greylist: delayed 261 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Jan 2022 14:34:02 PST
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE00C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 14:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
        d=auristor.com; s=MDaemon; r=y; t=1641335379; x=1641940179;
        i=jaltman@auristor.com; q=dns/txt; h=Message-ID:Date:
        MIME-Version:User-Agent:Content-Language:To:From:Subject:
        Organization:Cc:Content-Type; bh=h3FVSFQ05E+BZutNU/yTLIz1l+3G1O6
        gNz1LEU1Yt/8=; b=kL/II/CJ9D8aCWunMLtCv7JeBmIg/K/ic8/4rIobmSJ2IFO
        vrXCWmTcyrr5lT/8r3j3vI8XOZOVne/hei/6/SqbRLUp27Y4kkfuPHgyNq8yfn5L
        AWvPnc5zUzE3mty6jJuavSVfyOVo6XRCTrjSxwAYlhYKPsdJSAZtjOT9b72w=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Tue, 04 Jan 2022 17:29:39 -0500
Received: from [IPV6:2603:7000:73d:4f22:c552:312a:d6eb:a5e0] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v21.5.1) 
        with ESMTPSA id md5001003050748.msg; Tue, 04 Jan 2022 17:29:38 -0500
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Tue, 04 Jan 2022 17:29:38 -0500
        (not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73d:4f22:c552:312a:d6eb:a5e0
X-MDHelo: [IPV6:2603:7000:73d:4f22:c552:312a:d6eb:a5e0]
X-MDArrival-Date: Tue, 04 Jan 2022 17:29:38 -0500
X-MDOrigin-Country: US, NA
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=100355f1fa=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: stable@vger.kernel.org
Message-ID: <8b47354f-ff8f-4dfe-6c1e-813ffefbcf79@auristor.com>
Date:   Tue, 4 Jan 2022 17:29:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Jeffrey E Altman <jaltman@auristor.com>
Subject: Backport request: commit 0dc54bd4d6e0 ("fscache_cookie_enabled: check
 cookie is valid before accessing it")
Organization: AuriStor, Inc.
Cc:     linux-afs@lists.infradead.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060909080908000802060701"
X-MDCFSigsAdded: auristor.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060909080908000802060701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Please backport commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab
("fscache_cookie_enabled: check cookie is valid before accessing it") to
the 5.13, 5.14, and 5.15 kernel series.

Commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab fixes a bug introduced
by 3003bbd0697b659944237f3459489cb596ba196c ("afs: Use the
netfs_write_begin() helper") that results in a NULL pointer dereference
observed in Fedora 35 when accessing afs volumes from Kubernetes.

[ 3627.403829] BUG: kernel NULL pointer dereference, address:
0000000000000068
[ 3627.411649] RIP: 0010:afs_is_cache_enabled+0xc/0x30 [kafs]
[ 3627.419900] Call Trace:
[ 3627.420432]  <TASK>
[ 3627.420957]  netfs_write_begin+0x1ff/0x810 [netfs]
[ 3627.421498]  ? lock_timer_base+0x61/0x80
[ 3627.422124]  afs_write_begin+0x58/0x240 [kafs]
[ 3627.422738]  generic_perform_write+0xae/0x1d0
[ 3627.423325]  ? file_update_time+0xd2/0x120
[ 3627.423806]  __generic_file_write_iter+0x101/0x1d0
[ 3627.424275]  generic_file_write_iter+0x5d/0xb0
[ 3627.424741]  afs_file_write+0x73/0xa0 [kafs]
[ 3627.425270]  new_sync_write+0x10b/0x180
[ 3627.425708]  vfs_write+0x1ce/0x260
[ 3627.426160]  ksys_write+0x4f/0xc0
[ 3627.426606]  do_syscall_64+0x3b/0x90
[ 3627.427086]  entry_SYSCALL_64_after_hwframe+0x44/0xae

The defect was introduced in v5.13-rc1 and fixed in v5.16-rc1.

Thank you and Happy New Year.

Jeffrey Altman


--------------ms060909080908000802060701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DGswggXSMIIEuqADAgECAhBAAW0B1qVVQ32wvx2EXYU6MA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEy
MB4XDTE5MDkwNTE0MzE0N1oXDTIyMTEwMTE0MzE0N1owcDEvMC0GCgmSJomT8ixkAQETH0Ew
MTQxMEMwMDAwMDE2RDAxRDZBNTQwMDAwMDQ0NDcxGTAXBgNVBAMTEEplZmZyZXkgRSBBbHRt
YW4xFTATBgNVBAoTDEF1cmlTdG9yIEluYzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCY1TC9QeWnUgEoJ81FcAVnhGn/AWuzvkYRUG5/ZyXDdaM212e8
ybCklgSmZweqNdrfaaHXk9vwjpvpD4YWgb07nJ1QBwlvRV/VPAaDdneIygJJWBCzaMVLttKO
0VimH/I/HUwFBQT2mrktucCEf2qogdi2P+p5nuhnhIUiyZ71Fo43gF6cuXIMV/1rBNIJDuwM
Q3H8zi6GL0p4mZFZDDKtbYq2l8+MNxFvMrYcLaJqejQNQRBuZVfv0Fq9pOGwNLAk19baIw3U
xdwx+bGpTtS63Py1/57MQ0W/ZXE/Ocnt1qoDLpJeZIuEBKgMcn5/iN9+Ro5zAuOBEKg34wBS
8QCTAgMBAAGjggKcMIICmDAOBgNVHQ8BAf8EBAMCBPAwgYQGCCsGAQUFBwEBBHgwdjAwBggr
BgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEIGCCsGAQUF
BzAChjZodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NlcnRzL3RydXN0aWRjYWEx
Mi5wN2MwHwYDVR0jBBgwFoAUpHPa72k1inXMoBl7CDL4a4nkQuwwCQYDVR0TBAIwADCCASsG
A1UdIASCASIwggEeMIIBGgYLYIZIAYb5LwAGAgEwggEJMEoGCCsGAQUFBwIBFj5odHRwczov
L3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRt
bDCBugYIKwYBBQUHAgIwga0MgapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFzIGJlZW4g
aXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENlcnRpZmlj
YXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRp
ZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8v
dmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90cnVzdGlkY2FhMTIuY3JsMB8GA1UdEQQY
MBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1UdDgQWBBR7pHsvL4H5GdzNToI9e5BuzV19
bzAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAFlm
JYk4Ff1v/n0foZkv661W4LCRtroBaVykOXetrDDOQNK2N6JdTa146uIZVgBeU+S/0DLvJBKY
tkUHQ9ovjXJTsuCBmhIIw3YlHoFxbku0wHEpXMdFUHV3tUodFJJKF3MbC8j7dOMkag59/Mdz
Sjszdvit0av9nTxWs/tRKKtSQQlxtH34TouIke2UgP/Nn901QLOrJYJmtjzVz8DW3IYVxfci
SBHhbhJTdley5cuEzphELo5NR4gFjBNlxH7G57Hno9+EWILpx302FJMwTgodIBJbXLbPMHou
xQbOL2anOTUMKO8oH0QdQHCtC7hpgoQa7UJYJxDBI+PRaQ/HObkwggaRMIIEeaADAgECAhEA
+d5Wf8lNDHdw+WAbUtoVOzANBgkqhkiG9w0BAQsFADBKMQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MScwJQYDVQQDEx5JZGVuVHJ1c3QgQ29tbWVyY2lhbCBSb290IENBIDEw
HhcNMTUwMjE4MjIyNTE5WhcNMjMwMjE4MjIyNTE5WjA6MQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElEIENBIEExMjCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBANGRTTzPCic0kq5L6ZrUJWt5LE/n6tbPXPhGt2Egv7plJMoEpvVJ
JDqGqDYymaAsd8Hn9ZMAuKUEFdlx5PgCkfu7jL5zgiMNnAFVD9PyrsuF+poqmlxhlQ06sFY2
hbhQkVVQ00KCNgUzKcBUIvjv04w+fhNPkwGW5M7Ae5K5OGFGwOoRck9GG6MUVKvTNkBw2/vN
MOd29VGVTtR0tjH5PS5yDXss48Yl1P4hDStO2L4wTsW2P37QGD27//XGN8K6amWB6F2XOgff
/PmlQjQOORT95PmLkwwvma5nj0AS0CVp8kv0K2RHV7GonllKpFDMT0CkxMQKwoj+tWEWJTiD
KSsCAwEAAaOCAoAwggJ8MIGJBggrBgEFBQcBAQR9MHswMAYIKwYBBQUHMAGGJGh0dHA6Ly9j
b21tZXJjaWFsLm9jc3AuaWRlbnRydXN0LmNvbTBHBggrBgEFBQcwAoY7aHR0cDovL3ZhbGlk
YXRpb24uaWRlbnRydXN0LmNvbS9yb290cy9jb21tZXJjaWFscm9vdGNhMS5wN2MwHwYDVR0j
BBgwFoAU7UQZwNPwBovupHu+QucmVMiONnYwDwYDVR0TAQH/BAUwAwEB/zCCASAGA1UdIASC
ARcwggETMIIBDwYEVR0gADCCAQUwggEBBggrBgEFBQcCAjCB9DBFFj5odHRwczovL3NlY3Vy
ZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDADAgEB
GoGqVGhpcyBUcnVzdElEIENlcnRpZmljYXRlIGhhcyBiZWVuIGlzc3VlZCBpbiBhY2NvcmRh
bmNlIHdpdGggSWRlblRydXN0J3MgVHJ1c3RJRCBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQg
YXQgaHR0cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L3Rz
L2luZGV4Lmh0bWwwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRy
dXN0LmNvbS9jcmwvY29tbWVyY2lhbHJvb3RjYTEuY3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMC
BggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0OBBYEFKRz2u9pNYp1zKAZewgy+GuJ
5ELsMA0GCSqGSIb3DQEBCwUAA4ICAQAN4YKu0vv062MZfg+xMSNUXYKvHwvZIk+6H1pUmivy
DI4I6A3wWzxlr83ZJm0oGIF6PBsbgKJ/fhyyIzb+vAYFJmyI8I/0mGlc+nIQNuV2XY8cypPo
VJKgpnzp/7cECXkX8R4NyPtEn8KecbNdGBdEaG4a7AkZ3ujlJofZqYdHxN29tZPdDlZ8fR36
/mAFeCEq0wOtOOc0Eyhs29+9MIZYjyxaPoTS+l8xLcuYX3RWlirRyH6RPfeAi5kySOEhG1qu
NHe06QIwpigjyFT6v/vRqoIBr7WpDOSt1VzXPVbSj1PcWBgkwyGKHlQUOuSbHbHcjOD8w8wH
SDbL+L2he8hNN54doy1e1wJHKmnfb0uBAeISoxRbJnMMWvgAlH5FVrQWlgajeH/6NbYbBSRx
ALuEOqEQepmJM6qz4oD2sxdq4GMN5adAdYEswkY/o0bRKyFXTD3mdqeRXce0jYQbWm7oapqS
ZBccFvUgYOrB78tB6c1bxIgaQKRShtWR1zMM0JfqUfD9u8Fg7G5SVO0IG/GcxkSvZeRjhYcb
TfqF2eAgprpyzLWmdr0mou3bv1Sq4OuBhmTQCnqxAXr4yVTRYHkp5lCvRgeJAme1OTVpVPth
/O7HJ7VuEP9GOr6kCXCXmjB4P3UJ2oU0NqfoQdcSSSt9hliALnExTEjii20B2nSDojGCAxQw
ggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UEAxMO
VHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowDQYJYIZIAWUDBAIBBQCgggGXMBgG
CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEwNDIyMjkzNFow
LwYJKoZIhvcNAQkEMSIEIDF26Hqg2fiOgNjg94mhHFXY/zhqlsaVeDwsPoCD1RIQMF0GCSsG
AQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UE
AxMOVHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowXwYLKoZIhvcNAQkQAgsxUKBO
MDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQg
Q0EgQTEyAhBAAW0B1qVVQ32wvx2EXYU6MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAbTdvXojmINBF
jL2euz1yZybNFlJp9p1jP0XQbhcPVKvGJeuEz8L0/L0oYFgHTczdWVPl5mQzk+KdLW6Be1XF
QPbm7CePjmGx8xYUiAvwXN89GHk4SKi2ZAeIgkMiukrBMKFmI/R8is5VEFq86IKAUPcDcLyA
33gwJCJa8MIzEcVCHFSgAvDY1I982m3Ohtd0lzjiW+jZN03yQiGCSvGKseGWRlFd+mepoLYv
NXwa3ugJU0I+P1TxH+CtjAkSMfu9SmRTfiK9mwuzSmZ8uKVOu2IYL82Db07548E+5bPIpd8i
bCydlA1m3FPzfiAVr9BZBKJWDSe4JR/lQ9DYXIqSqQAAAAAAAA==
--------------ms060909080908000802060701--

